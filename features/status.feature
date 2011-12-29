Feature: Status

	In order to comply with official nagios plugin development guidelines
	As a sysadmin building my own Nagios Plugins
	I want to return the status in a nagios compatible output

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
		Then the exit status should be <exit>
		# And the stdout should contain exactly:
		And the stdout should contain:
			"""
			<stdout>
			
			"""
		Examples:
		 | crit  | warn  | exit | stdout   |
		 | true  | true  | 2    | CRITICAL |
		 | true  | false | 2    | CRITICAL |
		 | false | true  | 1    | WARNING  |
		 | false | false | 0    | OK       |

	Scenario Outline: UNKNOWN when all status checks are false
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
		Then the exit status should be <exit>
		# And the stdout should contain exactly:
		And the stdout should contain:
			"""
			<stdout>
			
			"""
		Examples:
		 | ok    | exit | stdout                                          |
		 | true  | 0    | OK                                              |
		 | false | 3    | UNKNOWN: crit? warn? and ok? all returned false |

	Scenario: UNKNOWN when an exception was raised