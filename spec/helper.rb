$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start
require 'windy'
require 'rspec'
require 'webmock/rspec'


def a_get(path)
  a_request(:get, 'http://data.cityofchicago.org/' + path)
end

def stub_get(path)
  stub_request(:get, 'http://data.cityofchicago.org/' + path)
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

