When /^I run a plugin with the following methods:$/ do |methods|
  steps %Q{
    Given a file named "check_foo" with:
			"""
			require 'nagiosplugin'
			class Foo < NagiosPlugin::Plugin
        #{methods}
  		end
			Foo.check!
			"""
		When I run `ruby check_foo`
  }
end

Then /^the plugin should print "([^"]*)"$/ do |stdout|
  steps %Q{Then the stdout should contain "FOO #{stdout}"}
end
