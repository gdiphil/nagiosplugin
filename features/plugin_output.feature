Feature: Plugin Output

	In order to comply with official nagios plugin development guidelines
	As a sysadmin building my own nagios plugins
	I want to return a nagios compatible plugin output


	Scenario Outline: CRITICAL, WARNING and OK
		Given a file named "check_foo" with:
			"""
			require 'nagiosplugin'
			class Foo < NagiosPlugin::Plugin
	      def critical?;	<crit>	end
	      def warning?;		<warn>	end
	    end
			Foo.check!
			"""
		When I run `ruby check_foo`
		Then the exit status should be <code>
		And the stdout should contain "FOO <status>"
		
		Examples:
		 | crit  | warn  | code | status   |
		 | true  | true  | 2    | CRITICAL |
		 | true  | false | 2    | CRITICAL |
		 | false | true  | 1    | WARNING  |
		 | false | false | 0    | OK       |


	Scenario Outline: UNKNOWN when all status checks return false
		Given a file named "check_bar" with:
			"""
			require 'nagiosplugin'
			class Bar < NagiosPlugin::Plugin
  		  def critical?;	false		end
  		  def warning?;		false		end
				def ok?;				<ok>		end
  		end
			Bar.check!
			"""
		When I run `ruby check_bar`
		Then the exit status should be <code>
		And the stdout should contain "BAR <status>"
		
		Examples:
		 | ok    | code | status                                     |
		 | true  | 0    | OK                                         |
		 | false | 3    | UNKNOWN: All status checks returned false! |


	Scenario: UNKNOWN when an exception was raised
		Given a file named "check_baz" with:
			"""
			require 'nagiosplugin'
			class Baz < NagiosPlugin::Plugin
				def critical?
					raise "OOPS!"
				end
			end
			Baz.check!
			"""
		When I run `ruby check_baz`
		Then the exit status should be 3
		And the stdout should contain "BAZ UNKNOWN: OOPS!"

