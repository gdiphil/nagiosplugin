module NagiosPlugin
  class Plugin
    # All allowed statuses sorted by their corresponding exit status.
    STATUS = [:ok, :warning, :critical, :unknown]

    # A custom status error which will be raised through the status methods.
    class StatusError < StandardError
      # @param [Symbol] status the status (must be {NagiosPlugin::Plugin::STATUS a valid status})
      # @param [String] message the message you want to display
      def initialize(status, message)
        @status, @message = status.to_sym, message
      end

      # @return [Symbol] the status
      def status
        (STATUS.include?(@status) && @status) || STATUS.last
      end

      # @return [String] the status and message
      def to_s
        "#{status.to_s.upcase}: #{@message}"
      end

      # @return [Fixnum] the status converted into an exit code
      def to_i
        STATUS.find_index(status)
      end
    end

    class << self
      # Create new instance and run it.
      def run(*args)
        self.new(*args).run
      end
    end

    # The methods for each status.
    #
    # They should be called in your check method and will raise an appropriate
    # StatusError.
    #
    # @param [String] message
    STATUS.each do |status|
      define_method(status) do |message|
        raise StatusError.new(status, message)
      end
    end

    # Overwrite this check method and call a status method within!
    def check
      unknown 'please overwrite the method `check` in your class'
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
