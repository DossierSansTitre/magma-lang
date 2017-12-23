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
      name = decl.mangled_name
      @mod.functions.add(name, [], type)
    end

    def generate_fun(fun)
      table = {}
      block_pairs = []
      llvm_fun = @mod.functions[fun.mangled_name]
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
        if stmt.expr.nil?
          builder.ret_void
        else
          v = visit(stmt.expr, llvm_bb, table)
          builder.ret(v)
        end
      end
    end

    def expr_literal(expr, llvm_bb, table)
      expr.type.value(expr.value)
    end

    def expr_binary(expr, llvm_bb, table)
      lhs = visit(expr.lhs, llvm_bb, table)
      rhs = visit(expr.rhs, llvm_bb, table)

      llvm_bb.build do |builder|
        case expr.op
        when :add
          return builder.add(lhs, rhs)
        when :sub
          return builder.sub(lhs, rhs)
        when :mul
          return builder.mul(lhs, rhs)
        when :div
          return builder.sdiv(lhs, rhs)
        when :mod
          return builder.srem(lhs, rhs)
        when :eq
          return builder.icmp(:eq, lhs, rhs)
        when :ne
          return builder.icmp(:ne, lhs, rhs)
        when :gt
          return builder.icmp(:sgt, lhs, rhs)
        when :ge
          return builder.icmp(:sge, lhs, rhs)
        when :lt
          return builder.icmp(:slt, lhs, rhs)
        when :le
          return builder.icmp(:sle, lhs, rhs)
        when :or, :lor
          return builder.or(lhs, rhs)
        when :and, :land
          return builder.and(lhs, rhs)
        when :xor
          return builder.xor(lhs, rhs)
        when :lshift
          return builder.shl(lhs, rhs)
        when :rshift
          return builder.lshr(lhs, rhs)
        end
      end
    end
  end
end
