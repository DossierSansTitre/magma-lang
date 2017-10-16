module Magma
  class ErrorReporter
    class Error
      attr_reader :severity
      attr_reader :message
      attr_reader :location

      def initialize(severity, message, location)
        @severity = severity
        @message = message
        @location = location
      end
    end

    def initialize
      @errors = []
    end

    def push(severity, message, location)
      @errors << Error.new(severity, message, location)
    end

    def error(message, location)
      push(:error, message, location)
    end

    def warn(message, location)
      push(:warning, message, location)
    end

    def report
      @errors.each do |err|
        puts "#{err.severity}: #{err.location}: #{err.message}"
      end
    end

    def error?
      @errors.any?
    end
  end
end
