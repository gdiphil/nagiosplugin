module NagiosPlugin
  EXIT_CODES = {
    :ok       => 0,
    :warning  => 1,
    :critical => 2,
    :unknown  => 3,
  }
  
  PluginError = Class.new(StandardError)
  
  class Plugin
    def self.check!
      plugin = self.new
      plugin.check
    rescue Exception => e
      puts [plugin.prefix, e.to_s].join(' ')
    else
      puts plugin.message
    ensure
      exit plugin.code
    end
    
    def check
      measure if respond_to?(:measure)
      set_status
    rescue Exception
      @status = :unknown
      raise
    end
    
    def message
      [prefix, (output if respond_to?(:output))].compact.join(' ')
    end
    
    def prefix
      "#{self.class.name.upcase} #{status.to_s.upcase}:"
    end
    
    def code
      EXIT_CODES[status]
    end
    
    def status
      @status || :unknown
    end
    
    alias_method :to_s, :message
    alias_method :to_i, :code
  
  protected
  
    def set_status
      @status = [:critical, :warning, :ok].select { |s| send("#{s}?") }.first
      raise PluginError, "All status checks returned false!" if @status.nil?
    end
    
    def ok?
      true
    end
  end
end
