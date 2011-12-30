# NagiosPlugin

NagiosPlugin is a simple framework for writing [Nagios](http://www.nagios.org/) Plugins.

## Installation

	`gem install nagiosplugin`

## Usage

Create your executable plugin (which will be called by nagios), `require "nagiosplugin"` and subclass from `NagiosPlugin::Plugin`.
You must define the methods `critical?` and `warning?` which determine the plugin status during a check based on their boolean return value (`ok?` returns true by default but can be overwritten).
The optional method `measure` will be called *first* on every check to take samples.
Additional plugin output can be assigned to `@info_text`.
Run `check!` on your *class* to ensure a proper plugin output (= stdout & exit status).

Here's a simple example plugin named `check_u2d`:

````Ruby
#!/usr/bin/env ruby
require 'nagiosplugin'

class UnicornToDwarfRatio < NagiosPlugin::Plugin
	def measure
		@unicorns, @dwarves = ... # The algorithm is your homework.
	end
	
	def critical?
		@unicorns < @dwarves
	end
	
	def warning?
		@unicorns == @dwarves
	end
end

UnicornToDwarfRatio.check!
```

Please also take a look at features to see what's going on...

## Note on Patches/Pull Requests

* Fork the project and run `bundle install` to resolve all development dependencies.
* Add specs and/or features for it. This is important so I don't break it in a future version unintentionally.
* Make your feature addition or bug fix.
* Commit, do not mess with the Rakefile or gemspec.
  (If you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull.)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Björn Albers. See LICENSE for details.