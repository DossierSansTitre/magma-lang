require 'magma/scanner'
require 'magma/parser'

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
      scanner = Scanner.new(filename, f)
      parser = Parser.new(scanner)
      ap parser.parse
    end

    def self.run(args)
      cli = new(args)
      cli.exec
    end
  end
end
