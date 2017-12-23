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
        decl = @sema.add_function_decl(name, type, [])
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
      bb = sema_fun.add_basic_block
      ast_fun.block.statements.each do |stmt|
        visit(stmt, bb, sema_fun)
      end
    end

    def statement_return(stmt, bb, sema_fun)
      unless stmt.expr.nil?
        expr = visit(stmt.expr, bb, sema_fun)
      end
      bb.add_return(expr)
    end

    def statement_expr(stmt, bb, sema_fun)
      bb.add_expr(visit(stmt.expr, bb, sema_fun))
    end

    def expr_literal(expr, bb, sema_fun)
      type = expr.type
      value = expr.value
      sema_type = @sema.types[type]
      Sema::Expr.literal(sema_type, value)
    end

    def expr_binary(expr, bb, sema_fun)
      lhs = visit(expr.lhs, bb, sema_fun)
      rhs = visit(expr.rhs, bb, sema_fun)
      Sema::Expr.binary(expr.op, lhs, rhs)
    end

    def expr_unary(expr, bb, sema_fun)
      e = visit(expr.expr, bb, sema_fun)
      Sema::Expr.unary(expr.op, e)
    end
  end
end
