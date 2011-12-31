Feature: Plugin Output

	In order to comply with official nagios plugin development guidelines
	As a sysadmin building my own nagios plugins
	I want to return a nagios compatible plugin output

	Scenario Outline: CRITICAL, WARNING and OK
		When I run a plugin with the following methods:
			"""
	    def critical?;	<crit>	end
	    def warning?;		<warn>	end
			"""
		Then the exit status should be <code>
		And the plugin should print "<status>"
		
		Examples:
		 | crit  | warn  | code | status   |
		 | true  | true  | 2    | CRITICAL |
		 | true  | false | 2    | CRITICAL |
		 | false | true  | 1    | WARNING  |
		 | false | false | 0    | OK       |

	Scenario Outline: UNKNOWN when all status checks return false
		When I run a plugin with the following methods:
			"""
  		def critical?;	false		end
  		def warning?;		false		end
			def ok?;				<ok>		end
			"""
		Then the exit status should be <code>
		And the plugin should print "<status>"
		
		Examples:
		 | ok    | code | status                                     |
		 | true  | 0    | OK                                         |
		 | false | 3    | UNKNOWN: All status checks returned false! |

	Scenario: UNKNOWN when an exception was raised
		When I run a plugin with the following methods:
			"""
			def critical?
				raise "OOPS!"
			end
			"""
		Then the exit status should be 3
		And the plugin should print "UNKNOWN: OOPS!"
