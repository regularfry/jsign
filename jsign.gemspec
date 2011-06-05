# encoding: utf-8

libpath = File.expand_path("lib")
$:.unshift( libpath ) unless $:.include?( libpath )

require 'jsign/version'

Gem::Specification.new do |s|
  s.name        = "jsign"
  s.version     = Jsign::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alex Young"]
  s.email       = ["alex@blackkettle.org"]
  s.homepage    = "http://github.com/regularfry/jsign"
  s.summary     = "Make and verify signed JSON objects."
  s.description = "Jsign uses OpenSSL to sign JSON serialisations. The signed objects are valid JSON objects themselves."
 
  s.rubyforge_project         = "jsign"
 
  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{bin,lib}/**/*")
  s.require_path = 'lib'
end
