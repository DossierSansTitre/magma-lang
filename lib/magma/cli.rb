require 'magma/scanner'
require 'magma/parser'
require 'magma/error_reporter'
require 'magma/codegen'

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
        out_filename = File.basename(filename, File.extname(filename)) + '.o'
        codegen = Codegen.new(ast, out_filename)
        codegen.generate
      end
    end

    def self.run(args)
      cli = new(args)
      cli.exec
    end
  end
end
