Feature: NagiosPlugin Usage

  In order to write awesome Nagios Plugins with minimal effort
  As a busy (developer|sysadmin|devop|hacker|superhero|rockstar)
  I want to use the one NagiosPlugin framework

  Scenario Outline: Subclass from NagiosPlugin
    Given a file named "check_foo.rb" with:
      """
      require 'nagiosplugin'

      class Foo < NagiosPlugin::Plugin
        def check
          case ARGV.first
            when 'UNKNOWN'  then unknown  'no clue, sorry'
            when 'CRITICAL' then critical 'booooom!'
            when 'WARNING'  then warning  'it could be worse'
            when 'OK'       then ok       'all is fine'
          end
        end
      end

      Foo.run
      """
    When I run `ruby check_foo.rb <status>`
    Then the exit status should be <code>
    And the stdout should contain exactly:
      """
      <stdout>

      """

    Examples:
     | status   | code | stdout                         |
     | UNKNOWN  | 3    | FOO UNKNOWN: no clue, sorry    |
     | CRITICAL | 2    | FOO CRITICAL: booooom!         |
     | WARNING  | 1    | FOO WARNING: it could be worse |
     | OK       | 0    | FOO OK: all is fine            |
