require 'faraday'
require 'multi_json'

module Windy
  VERSION = '0.1.1'

  class << self
    attr_accessor :app_token, :debug
  end

  class SocrataAppTokenMiddleware < Faraday::Middleware
    def call(env)
      raise "You must specify an app token" if !Windy.app_token
      env[:request_headers]["X-App-Token"] = Windy.app_token
      @app.call env
    end
  end

  class Base
    def self.root
      "http://data.cityofchicago.org"
    end

    attr_reader :connection

    def initialize
      @connection = Faraday.new(:url => self.class.root) do |builder|
        builder.use SocrataAppTokenMiddleware
        builder.request :json

        # Enable logger output with Windy.debug = true
        if Windy.debug
          builder.response :logger
        end

        builder.adapter :net_http
      end
    end

    def body
      @body ||= connection.get(path) do |request|
        prepare_request(request)
        # warn "Fetching #{request.to_env(@connection)[:url]}"
      end.body
    end

    def prepare_request(request)
    end

    def json
      # For some reason ruby 1.9.x seems to be trying to parse the
      # API JSON output as ASCII instead of UTF-8
      body.force_encoding("UTF-8") unless body.nil? || !body.respond_to?(:force_encoding)
      @json ||= MultiJson.decode(body)
    end

    def inspect
      "#<#{self.class.name} #{self.class.root}#{path}>"
    end
  end

  module Finders
    def [](index)
      to_a[index]
    end

    def respond_to?(method)
      method.to_s[/^find(_all)?_by_./] || super
    end

    def method_missing(method, *args, &block)
      if attribute = method.to_s[/^(find(_all)?)_by_(.+)$/, 3]
        value = args.first
        send($1) { |record| record.send(attribute) == value }
      else
        super
      end
    end
  end

  class PaginatedCollection < Base
    include Enumerable, Finders

    def initialize
      @pages ||= {}
    end

    def page(number)
      @pages[number] ||= Page.new(self, number)
    end

    def each_page
      number = 1
      loop do
        page = self.page(number)
        break if page.count.zero?
        yield page
        number += 1
      end
    end

    def each(&block)
      each_page do |page|
        page.each(&block)
      end
    end
  end

  class Collection < Base
    include Enumerable, Finders

    def each(&block)
      records.each(&block)
    end

    def record_attributes
      json
    end

    def records
      @records ||= record_attributes.map do |attributes|
        create_record(attributes)
      end
    end

    def create_record(attributes)
      record_class.new(attributes)
    end
  end

  class Page < Collection
    attr_accessor :collection, :number

    def initialize(collection, number)
      @collection = collection
      @number = number
      super()
    end

    def path
      collection.path
    end

    def record_class
      collection.record_class
    end

    def prepare_request(request)
      request.params['limit'] = 200
      request.params['page'] = @number
    end
  end

  class Record
    undef_method(:id) if method_defined?(:id)

    attr_reader :attributes

    def initialize(attributes)
      self.attributes = attributes
    end

    def attributes=(attributes)
      @attributes = Windy.underscore(attributes)
    end

    def respond_to?(method)
      @attributes.has_key?(method.to_s) || super
    end

    def method_missing(method, *args, &block)
      if respond_to?(method)
        @attributes[method.to_s]
      else
        super
      end
    end

    def inspect
      "#<#{self.class.name}:#{id}>"
    end
  end

  class Views < PaginatedCollection
    def path
      "/api/views"
    end

    def record_class
      View
    end
  end

  class View < Record
    def columns
      @columns ||= Columns.new(id)
    end

    def rows
      @rows ||= Rows.new(id)
    end

    def inspect
      super[0..-2] + " #{name.inspect}>"
    end
  end

  class Columns < Collection
    def initialize(id)
      @id = id
      super()
    end

    def path
      "/api/views/#{@id}/columns.json"
    end

    def record_class
      Column
    end
  end

  class Column < Record
    def inspect
      "#<#{self.class.name}:#{id} #{name.inspect}>"
    end
  end

  class Rows < Collection
    def initialize(id)
      @id = id
      super()
    end

    def path
      "/api/views/#{@id}/rows.json"
    end

    def record_class
      Row
    end

    def record_attributes
      json['data']
    end

    def columns
      @columns ||= json['meta']['view']['columns'].map { |column| column['name'].downcase }
    end

    def column_index(name)
      columns.index(name.to_s.downcase)
    end

    def create_record(attributes)
      record_class.new(self, attributes)
    end
  end

  class Row
    undef_method(:id) if method_defined?(:id)

    attr_reader :collection, :values

    def initialize(collection, values)
      @collection = collection
      @values = values
    end

    def [](index_or_name)
      if index_or_name.is_a?(Integer)
        values[index_or_name]
      elsif index = collection.column_index(index_or_name)
        values[index]
      end
    end

    def method_missing(method, *args, &block)
      name = method.to_s.gsub('_', ' ')
      if collection.column_index(name)
        self[name]
      else
        super
      end
    end

    def length
      values.length
    end

    def to_a
      values
    end

    def inspect
      "#<#{self.class.name} #{values.inspect}>"
    end
  end

  def self.views
    @views ||= Views.new
  end

  def self.underscore(hash)
    Hash.new.tap do |result|
      hash.each do |original_key, value|
        new_key = original_key.gsub(/([a-z])([A-Z])/) { "#{$1}_#{$2.downcase}" }
        result[new_key] = value.is_a?(Hash) ? underscore(value) : value
      end
    end
  end
end
