require 'llvm/linker'
require 'magma/visitor'

module Magma
  class CodeGenerator
    include Visitor

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
      @sema.function_decls.each {|_, decl| generate_decl(decl)}
      @sema.functions.each {|_, fun| generate_fun(fun)}
    end

    def generate_decl(decl)
      type = decl.type.to_llvm
      name = decl.name
      @mod.functions.add(name, [], type)
    end

    def generate_fun(fun)
      table = {}
      block_pairs = []
      llvm_fun = @mod.functions[fun.name]
      fun.basic_blocks.each do |sema_bb|
        llvm_bb = llvm_fun.basic_blocks.append
        table[sema_bb.id] = llvm_bb
        block_pairs << [llvm_bb, sema_bb]
      end
      block_pairs.each do |pair|
        generate_basic_block(*pair, table)
      end
    end

    def generate_basic_block(llvm_bb, sema_bb, table)
      sema_bb.statements.each do |stmt|
        visit(stmt, llvm_bb, table)
      end
    end

    def statement_return(stmt, llvm_bb, table)
      llvm_bb.build do |builder|
        builder.ret_void
      end
    end
  end
end
