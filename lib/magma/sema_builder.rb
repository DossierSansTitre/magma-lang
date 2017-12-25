require 'magma/sema'
require 'magma/sema/expr'
require 'magma/visitor'

module Magma
  class SemaBuilder
    include Visitor

    def self.run(ast)
      builder = self.new(ast)
      builder.build
      builder.sema
    end

    def initialize(ast)
      @ast = ast
      @sema = Sema.new
    end

    def sema
      @sema
    end

    def build
      fun_pairs = []
      @ast.functions.each do |ast_fun|
        text_type = ast_fun.type
        type = @sema.types[text_type]
        name = ast_fun.name
        params = ast_fun.params
        param_types = params.map(&:type).map {|x| @sema.types[x]}
        decl = @sema.add_function_decl(name, type, param_types)
        unless ast_fun.block.nil?
          sema_fun = @sema.add_function(decl)
          fun_pairs << [sema_fun, ast_fun]
        end
      end
      fun_pairs.each do |pair|
        build_fun(*pair)
      end
    end

    def build_fun(sema_fun, ast_fun)
      @sema_fun = sema_fun
      bb = sema_fun.add_basic_block
      @block_stack = [bb]
      var_table = {}
      ast_fun.params.each_with_index do |param, i|
        var_table[param.name] = i
      end
      @var_table_stack = [var_table]
      ast_fun.block.statements.each do |stmt|
        visit(stmt)
      end
    end

    def statement_null(stmt)
      nil
    end

    def statement_cond(stmt)
      e = visit(stmt.expr)
      block_true = @sema_fun.add_basic_block
      if stmt.block_false
        block_false = @sema_fun.add_basic_block
      end
      block_next = @sema_fun.add_basic_block
      block_current = @block_stack.last
      @block_stack.pop
      @block_stack << block_next
      @block_stack << block_true
      stmt.block_true.statements.each do |s|
        visit(s)
      end
      block_true_end = @block_stack.pop
      block_true_end.add_jump(block_next)
      if block_false
        @block_stack << block_false
        stmt.block_false.statements.each do |s|
          visit(s)
        end
        block_false_end = @block_stack.pop
        block_false_end.add_jump(block_next)
        block_current.add_cond(e, block_true, block_false)
      else
        block_current.add_cond(e, block_true, block_next)
      end
    end

    def statement_return(stmt)
      unless stmt.expr.nil?
        expr = visit(stmt.expr)
      end
      @block_stack.last.add_return(expr)
    end

    def statement_expr(stmt)
      @block_stack.last.add_expr(visit(stmt.expr))
    end

    def statement_variable(stmt)
      name = stmt.name
      type = @sema.types[stmt.type]
      id = @sema_fun.add_var(type)
      @var_table_stack.last[name] = id
    end

    def statement_while(stmt)
      cond_block = @sema_fun.add_basic_block
      loop_block = @sema_fun.add_basic_block
      next_block = @sema_fun.add_basic_block
      current_block = @block_stack.pop
      e = visit(stmt.expr)
      cond_block.add_cond(e, loop_block, next_block)
      current_block.add_jump(cond_block)
      @block_stack << next_block
      @block_stack << loop_block
      stmt.block.statements.each {|s| visit(s)}
      loop_block_end = @block_stack.pop
      loop_block_end.add_jump(cond_block)
    end

    def statement_for(stmt)
      if stmt.init
        init = visit(stmt.init)
      end
      if stmt.expr
        expr = visit(stmt.expr)
      end
      if stmt.step
        step = visit(stmt.step)
      end

      cond_block = @sema_fun.add_basic_block
      loop_block = @sema_fun.add_basic_block
      next_block = @sema_fun.add_basic_block
      current_block = @block_stack.pop

      if init
        current_block.add_expr(init)
      end

      if expr
        cond_block.add_cond(expr, loop_block, next_block)
      else
        cond_block.add_jump(loop_block)
      end

      current_block.add_jump(cond_block)
      @block_stack << next_block
      @block_stack << loop_block
      stmt.block.statements.each {|s| visit(s)}
      loop_block_end = @block_stack.pop
      if step
        loop_block_end.add_expr(step)
      end
      loop_block_end.add_jump(cond_block)
    end


    def expr_assign(expr)
      name = expr.name
      id = @var_table_stack.last[name]
      type = @sema_fun.vars[id]
      e = visit(expr.expr)
      Sema::Expr.assign(id, type, e)
    end

    def expr_identifier(expr)
      name = expr.name
      id = @var_table_stack.last[name]
      type = @sema_fun.vars[id]
      Sema::Expr.variable(id, type)
    end

    def expr_literal(expr)
      type = expr.type
      value = expr.value
      sema_type = @sema.types[type]
      Sema::Expr.literal(sema_type, value)
    end

    def expr_binary(expr)
      lhs = visit(expr.lhs)
      rhs = visit(expr.rhs)
      Sema::Expr.binary(expr.op, lhs, rhs)
    end

    def expr_unary(expr)
      e = visit(expr.expr)
      Sema::Expr.unary(expr.op, e)
    end

    def expr_call(expr)
      fun_name = expr.name
      args = expr.arguments.map { |a|
        visit(a)
      }
      decl = @sema.decls_with_name(fun_name).first
      Sema::Expr.call(decl, args)
    end
  end
end
