# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "open311-validator"
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = "SeeClickFix (Jeff Blasius)"
  s.email       = 'dev@seeclickfix.com'
  s.homepage    = 'http://github.com/seeclickfix/open311-validator'
  s.summary     = "Open311 Validator"
  s.description = "A command line Open311 validator. (http://open311.org)"

  s.required_rubygems_version = ">= 1.3.5"

  s.add_dependency "httparty"
  s.add_dependency "rspec"
  
  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
