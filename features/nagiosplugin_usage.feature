Feature: NagiosPlugin Usage

  In order to write awesome Nagios Plugins with minimal effort
  As a busy (developer|sysadmin|devop|hacker|superhero|rockstar)
  I want to use the one NagiosPlugin framework

  Scenario Outline: Subclass from NagiosPlugin
    Given a file named "check_fancy.rb" with:
      """
      require 'nagiosplugin'

      class FancyPlugin < NagiosPlugin::Plugin
        def critical?
          <critical>
        end

        def warning?
          <warning>
        end

        def ok?
          <ok>
        end

        def message
          'answer is 42'
        end
      end

      FancyPlugin.check
      """
    When I run `ruby check_fancy.rb`
    Then the exit status should be <code>
    And the stdout should contain exactly:
      """
      <stdout>

      """

    Examples:
     | critical | warning | ok    | status   | code | stdout                       |
     | true     | true    | true  | CRITICAL | 2    | FANCY CRITICAL: answer is 42 |
     | false    | true    | true  | WARNING  | 1    | FANCY WARNING: answer is 42  |
     | false    | false   | true  | OK       | 0    | FANCY OK: answer is 42       |
     | false    | false   | false | UNKNOWN  | 3    | FANCY UNKNOWN: answer is 42  |
