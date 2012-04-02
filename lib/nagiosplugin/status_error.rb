module NagiosPlugin

    # A custom status error which will be raised through the status methods.
    class StatusError < StandardError

      # All allowed statuses sorted by their corresponding exit status.
      STATUS = [:ok, :warning, :critical, :unknown]

      # @param [Symbol] status the status (must be {NagiosPlugin::Plugin::StatusError::STATUS a valid status})
      # @param [String] message the message you want to display
      def initialize(status, message)
        @status, @message = status.to_sym, message
      end

      # @return [String] the status and message
      def to_s
        "#{status.to_s.upcase}: #{@message}"
      end

      # @return [Fixnum] the status converted into an exit code
      def to_i
        STATUS.find_index(status)
      end

    private

      # @return [Symbol] the status (:unknown if invalid)
      def status
        (STATUS.include?(@status) && @status) || STATUS.last
      end
    end
end
