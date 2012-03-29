Feature: Plugin Output

  In order to comply with official nagios plugin development guidelines
  As a sysadmin building my own nagios plugins
  I want to return a nagios compatible plugin output

  Scenario Outline: UNKNOWN, CRITICAL, WARNING and OK
    Given a file named "check_foo.rb" with:
      """
      require 'nagiosplugin'

      class Foo < NagiosPlugin::Plugin
        def check
          status = ARGV.first
          unknown if status == "UNKNOWN"
          critical if status == "CRITICAL"
          warning if status == "WARNING"
          ok if status == "OK"
        end
      end

      Foo.run
      """
    When I run `ruby check_foo.rb <status>`
    Then the exit status should be <code>
    And the stdout should contain "<status>"

    Examples:
     | status   | code |
     | UNKNOWN  | 3    |
     | CRITICAL | 2    |
     | WARNING  | 1    |
     | OK       | 0    |

  Scenario: UNKNOWN when no status method was called
    Given a file named "check_foo" with:
      """
      require 'nagiosplugin'

      class Foo < NagiosPlugin::Plugin
        def check
        end
      end

      Foo.run
      """
    When I run `ruby check_foo`
    Then the exit status should be 3
    And the stdout should contain "UNKNOWN"
