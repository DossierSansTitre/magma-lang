require 'llvm/target'

module Magma
  class Codegen
    def initialize(ast, filename)
      @ast = ast
      @filename = filename
    end

    def generate
      mod = @ast.generate
      mod.dump
      LLVM::Target.init_native(true)
      target = LLVM::Target.each.first
      tm = target.create_machine("x86_64-apple-darwin")
      tm.emit(mod, @filename, :object)
    end
  end
end
