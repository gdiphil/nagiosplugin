module NagiosPlugin
  class Plugin
    class << self

      # Create new instance and run it.
      def run(*args)
        self.new(*args).run
      end

    private

      # @macro [status] message
      #   @method $1(message)
      #   Raise $1 StatusError with message
      #   @param [String] message the exeption message
      def make(status)
        define_method(status) do |message|
          raise StatusError.new(status, message)
        end
      end
    end

    make :ok
    make :warning
    make :critical
    make :unknown

    # Overwrite this check method and call a status method within.
    def check
      unknown 'please overwrite the `check` method in your class'
    end

    # Run check and return result in a nagios-compatible format.
    #
    # It will...
    # - execute your check method
    # - output the result in a nagios-compatible format (SERVICE STATUS: Message)
    # - exit according to the status
    def run
      check
    rescue StatusError => e
    rescue => e
      e = StatusError.new(:unknown, ([e.to_s, nil] + e.backtrace).join("\n"))
    else
      e = StatusError.new(:unknown, 'no status method was called')
    ensure
      puts [self.class.name.upcase, e.to_s].join(' ')
      exit e.to_i
    end
  end
end
