# NagiosPlugin

A simple framework for writing [Nagios](http://www.nagios.org/) Plugins.

## Installation

	`gem install nagiosplugin`

## Usage

Create your executable file (which will be called by nagios), `require
'nagiosplugin'` and subclass from `NagiosPlugin::Plugin`.

Then define a check method in your class which figures out the status
for what you want to check and calls the corresponding status method
(`ok`, `warning`, `critical` or `unknown`) to display a status message
and exit imediately.

Here's a simple example plugin named `check_u2d`:

```Ruby
#!/usr/bin/env ruby
require 'nagiosplugin'

class UnicornToDwarfRatio < NagiosPlugin::Plugin
	def check
    unicorn_to_dwarf_ratio = ... # We still need an alogrithm for this.
    msg = "#{unicorn_to_dwarf_ratio} unicorns/dwarves"

    critical(msg) if unicorn_to_dwarf_ratio < 0.0
    warning(msg) if unicorn_to_dwarf_ratio == 0.0
    ok(msg)
  end
end

UnicornToDwarfRatio.run
```

Take a look below `features` to see what's going on...

## Note on Patches/Pull Requests

* Fork the project and run `bundle install` to resolve all development dependencies.
* Add specs and/or features for it. This is important so I don't break it in a future version unintentionally.
* Make your feature addition or bug fix.
* Commit, do not mess with the Rakefile or gemspec.
  (If you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull.)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011-2012 Björn Albers. See LICENSE for details.
