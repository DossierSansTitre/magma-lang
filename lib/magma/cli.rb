require 'magma/scanner'

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
      tokens = []
      loop do
        t = scanner.next_token
        break if t.nil?
        tokens << t
      end
      f.close
      ap tokens
    end

    def self.run(args)
      cli = new(args)
      cli.exec
    end
  end
end
