require 'llvm/linker'

module Magma
  class CodeGenerator
    def self.run(sema)
      gen = self.new(sema)
      gen.generate
      gen.mod
    end

    def initialize(sema)
      @sema = sema
      @mod = LLVM::Module.new("Magma")
    end

    def mod
      @mod
    end

    def generate
    end
  end
end
