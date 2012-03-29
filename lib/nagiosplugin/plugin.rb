module NagiosPlugin
  class Plugin
    STATUS = [:ok, :warning, :critical, :unknown]

    class StatusError < StandardError
      def initialize(status, message)
        @status, @message = status.to_sym, message
      end

      def status
        (STATUS.include?(@status) && @status) || STATUS.last
      end

      def to_s
        "#{status.to_s.upcase}: #{@message}"
      end

      def to_i
        STATUS.find_index(status)
      end
    end

    STATUS.each do |status|
      define_method(status) do |message|
        raise StatusError.new(status, message)
      end
    end

    class << self
      def run(*args)
        self.new(*args).run
      end
    end

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
