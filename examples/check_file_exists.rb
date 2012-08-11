#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + "/lib")

require "nagiosplugin"

class MyPlugin < NagiosPlugin::Plugin
  VERSION = 1.0

  class << self
    def run(options)
      self.new(options).run
    end

    def default_options
      {
        :reverse => false
      }
    end

    def parse_options
      options = default_options

      blk = lambda do |opts|
        opts.on('-V', '--version', 'Print version.') do |s|
          abort("#{$0} #{VERSION}")
        end
        opts.on('-f', '--filename <name>', 'Filename that should exist.') do |s|
          options[:filename] = s
        end
      end

      super(options, &blk)
    end

  end
  def initialize(options)
    super(options)
    @filename = options[:filename]
  end

  def check
    if File.executable?(@filename)
      ok("#{@filename} is excutable")
    elsif File.exists?(@filename)
      warning("#{@filename} is not excutable")
    else
      critical("#{@filename} does not exist")
    end
  end

end


MyPlugin.run( MyPlugin.parse_options, *ARGV)
