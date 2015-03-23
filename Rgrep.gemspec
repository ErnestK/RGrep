# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "Rgrep/version"

Gem::Specification.new do |s|
  s.name        = "Rgrep"
  s.version     = Mygem::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ernest Khasanzhinov"]
  s.email       = ["khasanzhinov@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A sample gem}
  s.description = %q{A sample gem. Gem like grep in linux, but ruby.}

  s.add_runtime_dependency "launchy"
  s.add_runtime_dependency 'thor'
  s.add_development_dependency "rspec", "~>2.5.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end