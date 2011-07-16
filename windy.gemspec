Gem::Specification.new do |s|
  s.name        = "windy"
  s.version     = "0.1.0"
  s.summary     = "Ruby interface to the City of Chicago's Data Portal API"
  s.description = "Windy is a Ruby module that allows you to easily interact with the City of Chicago's Data Portal."

  s.files = ["README.md", "lib/windy.rb"]

  s.add_dependency "faraday",    "~> 0.7"
  s.add_dependency "multi_json", "~> 1.0"

  s.authors  = ["Sam Stephenson", "Scott Robbin"]
  s.email    = ["sstephenson@gmail.com", "srobbin@gmail.com"]
  s.homepage = "http://github.com/chicago/windy"
end
