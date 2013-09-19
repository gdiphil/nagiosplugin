# NagiosPlugin

The one [Nagios](http://www.nagios.org/) Plugin framework, forged in the
fires of Mount Doom.

[![Build
Status](https://secure.travis-ci.org/bjoernalbers/nagiosplugin.png)](http://travis-ci.org/bjoernalbers/nagiosplugin)

**NOTE: The API has changed since version 2.0 (see issue
[#2](https://github.com/bjoernalbers/nagiosplugin/issues/2))!!!**


## Installation

Via bundler: Add this to your Gemfile and run `bundle install`:

```Ruby
gem 'nagiosplugin'
```

Manually via Rubygems: Run `gem install nagiosplugin`.


## Usage

Writing your custom plugin is really simple:

### Step 1: Describe when something is critical, warning and ok.

Create your subclass from `NagiosPlugin::Plugin` and define these
instance methods to determine the status:

```Ruby
require 'nagiosplugin'

class MyFancyPlugin < NagiosPlugin::Plugin
  def critical?
    # Enter your code here (returns true when critical, else false).
  end

  def warning?
    # Enter your code here (returns true when warning, else false).
  end

  def ok?
    # Enter your code... you get the idea.
  end
end
```

**Please keep in mind that the "worst" status always wins, i.e. if both
`critical?` and `warning?` are true then the status would be critical
(if none is true, then the status would be unknown of course)!**

You may use your `initialize` method to setup check data (NagiosPlugin
doesn't use that either), parse CLI options, etc.

### Step 2: Provide some context via status message (optionally).

Ask yourself what might be important to know (and fits into a text
message) when Nagios just send you an alert in the middle of the night.

```Ruby
def message
  # Create an info string (this will be printed after the
  # status on stdout).
  # Service name, status and message should be longer than 78 chars!!!
end
```

### Step 3: Perform the actual check.

In your binary then call `check!` on your class and you're done:

```Ruby
MyFancyPlugin.new.check!
```

This will output the check result and exits in compliance with the
official
[Nagios plug-in development
guidelines](http://nagiosplug.sourceforge.net/developer-guidelines.html)

If anything funky happens in your code: NagiosPlugin does a "blind
rescue mission" and transforms any execptions to an unknown status.


## One more thing...

The API changed completely compared to v1.3 as well as the default command
line options (they are gone).
I suggest that you use 3rd party [CLI Option
Parsers](https://www.ruby-toolbox.com/categories/CLI_Option_Parsers)
because everyone has different preferences on this.

Please let me know if you find this usefull or if you want to contribute!


## Note on Patches/Pull Requests

* Fork the project and run `bundle install` to resolve all development
  dependencies.
* Add specs and/or features for it. This is important so I don't break
  it in a future version unintentionally.
* Make your feature addition or bug fix.
* Commit, do not mess with the Rakefile or gemspec.
  (If you want to have your own version, that is fine but bump version
in a commit by itself I can ignore when I pull.)
* Send me a pull request. Bonus points for topic branches.


## Acknowledgments

Thanks to the following contributors for improving NagiosPlugin:

* [szuecs (Sandor Szücs)](https://github.com/szuecs)


## Copyright

Copyright (c) 2011-2013 Björn Albers. See LICENSE for details.
