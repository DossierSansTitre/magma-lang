require 'llvm/target'
require 'llvm/transforms/builder'
require 'llvm/analysis'

module Magma
  class NativeCompiler
    def initialize(mod, filename, optimize)
      @mod = mod
      @filename = filename
      @optimize = optimize
    end

    def generate
      LLVM::Target.init_native(true)
      target = LLVM::Target.each.first
      tm = target.create_machine("x86_64-apple-darwin")
      if @optimize
        pmb = LLVM::PassManagerBuilder.new
        pmb.opt_level = 3
        pmb.unroll_loops = true
        pm = LLVM::PassManager.new(tm)
        pmb.build(pm)
        pm.run(@mod)
      end
      @mod.dump
      @mod.verify!
      tm.emit(@mod, @filename, :object)
    end
  end
end
