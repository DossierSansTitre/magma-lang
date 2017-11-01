require 'colorize'

module Magma
  class ErrorReporter
    COLORS = {
      :error    => :red,
      :warning  => :magenta
    }

    def initialize
      @stats = {}
    end

    def report(severity, message, location)
      @stats[severity] ||= 0
      @stats[severity] += 1
      print "#{location}: ".white.bold
      print "#{severity}: ".colorize(COLORS[severity]).bold
      print "#{message}\n".white.bold
      print "#{location.text.chomp}\n"
      print "#{' ' * location.column}^#{'~' * (location.length - 1)}\n".green.bold
    end

    def error(message, location)
      report(:error, message, location)
    end

    def warn(message, location)
      report(:warning, message, location)
    end

    def error?
      !@stats[:error].nil?
    end
  end
end
