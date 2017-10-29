require 'llvm/target'
require 'llvm/transforms/builder'
require 'magma/support/codegen_context'

module Magma
  class Codegen
    def initialize(ast, filename, optimize)
      @ast = ast
      @filename = filename
      @optimize = optimize
    end

    def generate
      ctx = Support::CodegenContext.new
      @ast.generate(ctx)
      LLVM::Target.init_native(true)
      target = LLVM::Target.each.first
      tm = target.create_machine("x86_64-apple-darwin")
      if @optimize
        pmb = LLVM::PassManagerBuilder.new
        pmb.opt_level = 2
        pmb.unroll_loops = true
        pm = LLVM::PassManager.new(tm)
        pmb.build(pm)
        pm.run(ctx.module)
      end
      ctx.module.dump
      tm.emit(ctx.module, @filename, :object)
    end
  end
end
