module Magma
  class CLI
    def initialize(args)
      @args = args
    end

    def exec
      ap @args
    end

    def self.run(args)
      cli = new(args)
      cli.exec
    end
  end
end
