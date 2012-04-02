# NagiosPlugin

The one [Nagios](http://www.nagios.org/) Plugin framework, forged in the fires of Mount Doom.

[![Build Status](https://secure.travis-ci.org/bjoernalbers/nagiosplugin.png)](http://travis-ci.org/bjoernalbers/nagiosplugin)

## Installation

	gem install nagiosplugin

## Usage

### Step 1

Just subclass from `NagiosPlugin::Plugin` and define your `check` method
which should figure out the status and then call the appropriate status
method (`ok`, `warning`, `critical` or `unknown`) with meaningfull message.
(The status methods will exit immediately by raising a corresponding StatusError.)

Take a look at a working [usage
example](https://github.com/bjoernalbers/nagiosplugin/blob/master/features/nagiosplugin_usage.feature).

### Step 2

Call the `run` method on your new class, which outputs the check result
and exits in compliance with the official [Nagios plug-in development
guidelines](http://nagiosplug.sourceforge.net/developer-guidelines.html)

### Step 3

Profit... and maybe also fun.

## Note on Patches/Pull Requests

* Fork the project and run `bundle install` to resolve all development dependencies.
* Add specs and/or features for it. This is important so I don't break it in a future version unintentionally.
* Make your feature addition or bug fix.
* Commit, do not mess with the Rakefile or gemspec.
  (If you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull.)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011-2012 Björn Albers. See LICENSE for details.
