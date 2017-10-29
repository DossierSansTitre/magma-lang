require 'llvm/target'
require 'magma/support/codegen_context'

module Magma
  class Codegen
    def initialize(ast, filename)
      @ast = ast
      @filename = filename
    end

    def generate
      ctx = Support::CodegenContext.new
      @ast.generate(ctx)
      ctx.module.dump
      LLVM::Target.init_native(true)
      target = LLVM::Target.each.first
      tm = target.create_machine("x86_64-apple-darwin")
      tm.emit(ctx.module, @filename, :object)
    end
  end
end
