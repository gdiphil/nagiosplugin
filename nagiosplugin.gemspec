# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nagiosplugin/version"

Gem::Specification.new do |s|
  s.name        = "nagiosplugin"
  s.version     = Nagiosplugin::VERSION
  s.authors     = ["Björn Albers"]
  s.email       = ["bjoernalbers@googlemail.com"]
  s.homepage    = "https://github.com/bjoernalbers/nagiosplugin"
  s.summary     = "#{s.name}-#{s.version}"
  s.description = "Yet another framework for writing Nagios Plugins"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
