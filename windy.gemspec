Gem::Specification.new do |s|
  s.name        = "windy"
  s.version     = "0.1.2"
  s.summary     = "Ruby interface to the City of Chicago's Data Portal API"
  s.description = "Windy is a Ruby module that allows you to easily interact with the City of Chicago's Data Portal."

  s.files = ["README.md", "lib/windy.rb"]

  s.add_dependency "faraday_middleware",    "~> 0.8"
  s.add_dependency "multi_json", "~> 1.0"
  s.add_development_dependency 'rspec', '~> 2.6'
  s.add_development_dependency 'simplecov', '~> 0.4'
  s.add_development_dependency 'webmock', '~> 1.7'

  s.authors  = ["Sam Stephenson", "Scott Robbin"]
  s.email    = ["sstephenson@gmail.com", "srobbin@gmail.com"]
  s.homepage = "http://github.com/chicago/windy"
end
