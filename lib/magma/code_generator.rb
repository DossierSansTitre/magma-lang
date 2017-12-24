require 'llvm/linker'
require 'magma/visitor'
require 'magma/code_generator/type_helper'

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
      type = TypeHelper.llvm(decl.type)
      name = decl.mangled_name
      d = @mod.functions.add(name, decl.args.map {|x| TypeHelper.llvm(x)}, type)
      d.params.each_with_index do |param, i|
        param.name = "arg#{i}"
      end
    end

    def generate_fun(fun)
      bb_table = {}
      block_pairs = []
      llvm_fun = @mod.functions[fun.mangled_name]
      first_block = nil
      fun.basic_blocks.each_with_index do |sema_bb, idx|
        if idx == 0
          bb_label = ""
        else
          bb_label = "#{fun.name}_#{idx}"
        end
        llvm_bb = llvm_fun.basic_blocks.append(bb_label)
        first_block ||= llvm_bb
        bb_table[sema_bb.id] = llvm_bb
        block_pairs << [llvm_bb, sema_bb]
      end
      var_table = []
      first_block.build do |builder|
        # Allocate variables
        fun.vars.each do |var|
          addr = builder.alloca(TypeHelper.llvm(var))
          var_table << addr
        end

        # Load func args into local variables
        llvm_fun.params.each.with_index do |param, i|
          builder.store(param, var_table[i])
        end
      end
      block_pairs.each do |pair|
        generate_basic_block(*pair, fun, bb_table, var_table)
      end
    end

    def generate_basic_block(llvm_bb, sema_bb, sema_fun, bb_table, var_table)
      sema_bb.statements.each do |stmt|
        visit(stmt, llvm_bb, sema_fun, bb_table, var_table)
      end
    end

    def statement_cond(stmt, llvm_bb, sema_fun, bb_table, var_table)
      e = visit(stmt.expr, llvm_bb, sema_fun, bb_table, var_table)
      llvm_bb.build do |builder|
        return builder.cond(e, bb_table[stmt.block_true.id], bb_table[stmt.block_false.id])
      end
    end

    def statement_return(stmt, llvm_bb, sema_fun, bb_table, var_table)
      unless stmt.expr.nil?
        v = visit(stmt.expr, llvm_bb, sema_fun, bb_table, var_table)
        v = TypeHelper.cast(llvm_bb, stmt.expr.type, sema_fun.type, v)
      end
      llvm_bb.build do |builder|
        if v.nil?
          builder.ret_void
        else
          builder.ret(v)
        end
      end
    end

    def expr_assign(expr, llvm_bb, sema_fun, bb_table, var_table)
      e = visit(expr.expr, llvm_bb, sema_fun, bb_table, var_table)
      src_type = expr.expr.type
      dst_type = expr.type
      e = TypeHelper.cast(llvm_bb, src_type, dst_type, e)
      llvm_bb.build do |builder|
        addr = var_table[expr.id]
        return builder.store(e, addr)
      end
    end

    def expr_literal(expr, llvm_bb, sema_fun, bb_table, var_table)
      TypeHelper.value(expr.type, expr.value)
    end

    def expr_call(expr, llvm_bb, sema_fun, bb_table, var_table)
      mangled_name = expr.decl.mangled_name
      f = @mod.functions[mangled_name]
      args = expr.exprs.map.with_index { |a, i|
        t = expr.decl.args[i]
        v = visit(a, llvm_bb, sema_fun, bb_table, var_table)
        TypeHelper.cast(llvm_bb, a.type, t, v)
      }
      llvm_bb.build do |builder|
        return builder.call(f, *args)
      end
    end

    def expr_binary(expr, llvm_bb, sema_fun, bb_table, var_table)
      lhs = visit(expr.lhs, llvm_bb, sema_fun, bb_table, var_table)
      rhs = visit(expr.rhs, llvm_bb, sema_fun, bb_table, var_table)

      source_type = expr.source_type

      lhs = TypeHelper.cast(llvm_bb, expr.lhs.type, source_type, lhs)
      rhs = TypeHelper.cast(llvm_bb, expr.rhs.type, source_type, rhs)

      llvm_bb.build do |builder|
        if source_type.kind == :int || source_type.kind == :bool
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
        else
          case expr.op
          when :add
            return builder.fadd(lhs, rhs)
          when :sub
            return builder.fsub(lhs, rhs)
          when :mul
            return builder.fmul(lhs, rhs)
          when :div
            return builder.fdiv(lhs, rhs)
          when :mod
            return builder.frem(lhs, rhs)
          when :eq
            return builder.fcmp(:eq, lhs, rhs)
          when :ne
            return builder.fcmp(:ne, lhs, rhs)
          when :gt
            return builder.fcmp(:sgt, lhs, rhs)
          when :ge
            return builder.fcmp(:sge, lhs, rhs)
          when :lt
            return builder.fcmp(:slt, lhs, rhs)
          when :le
            return builder.fcmp(:sle, lhs, rhs)
          end
        end
      end
    end

    def expr_unary(expr, llvm_bb, sema_fun, bb_table, var_table)
      e = visit(expr.expr, llvm_bb, sema_fun, bb_table, var_table)

      llvm_bb.build do |builder|
        case expr.op
        when :plus
          return e
        when :minus
          return builder.neg(e)
        when :lnot, :not
          return builder.not(e)
        end
      end
    end

    def expr_variable(expr, llvm_bb, sema_fun, bb_table, var_table)
      llvm_bb.build do |builder|
        return builder.load(var_table[expr.id])
      end
    end
  end
end
