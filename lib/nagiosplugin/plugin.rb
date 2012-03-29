module NagiosPlugin
  class Plugin
    class StatusError < StandardError
      attr_reader :status, :to_i
      def initialize(status, exit_code)
        @status, @to_i = status, exit_code
      end
    end

    %w[ok warning critical unknown].each_with_index do |status,exit_code|
      define_method(status) do |message|
        raise StatusError.new(status, exit_code), message
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
   rescue
     e = StatusError.new(:unknown, 3)
   else
     e = StatusError.new(:unknown, 3)
   ensure
     puts e.status.to_s.upcase + e.message
     exit(e.to_i)
   end
  end
end
