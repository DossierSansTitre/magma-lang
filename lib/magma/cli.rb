require 'magma/scanner'
require 'magma/parser'
require 'magma/error_reporter'

module Magma
  class CLI
    def initialize(args)
      @args = args
    end

    def exec
      filename = @args.shift
      if filename.nil?
        exit 1
      end
      f = File.open(filename, 'rb')
      reporter = ErrorReporter.new
      scanner = Scanner.new(filename, f, reporter)
      parser = Parser.new(scanner, reporter)
      ast = parser.parse
      f.close
      if reporter.error?
        reporter.report
      else
        ap parser.tokens
        ap ast
      end
    end

    def self.run(args)
      cli = new(args)
      cli.exec
    end
  end
end
