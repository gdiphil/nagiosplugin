module NagiosPlugin
  class Plugin
    NAGIOS_PLUGIN_EXIT_CODES = {
      :unknown  => 3,
      :critical => 2,
      :warning  => 1,
      :ok       => 0
    }

    class << self
      def check
        plugin = new
        puts plugin.nagios_plugin_output
        exit plugin.nagios_plugin_exit_code
      rescue => e
        puts "PLUGIN UNKNOWN: #{e.to_s}\n\n#{e.backtrace}"
        exit NAGIOS_PLUGIN_EXIT_CODES[:unknown]
      end
    end

    def nagios_plugin_exit_code
      NAGIOS_PLUGIN_EXIT_CODES[nagios_plugin_status]
    end

    def nagios_plugin_output
      output = [nagios_plugin_service] << ' '
      output << nagios_plugin_status.to_s.upcase
      output << ': ' + message if respond_to?(:message)
      output.join
    end

  private

    def nagios_plugin_status
      @nagios_plugin_status ||=
        case
        when critical? then :critical
        when warning?  then :warning
        when ok?       then :ok
        else                :unknown
        end
    end

    def nagios_plugin_service
      self.class.name.split('::').last.gsub(/plugin$/i, '').upcase
    end
  end
end
