require 'magma/visitor'

module Magma
  module SemaBuilder
    class FunctionVisitor
      include Visitor

      def initialize(ct, func)
        @ct = ct
        @func = func
        @basic_block = func.add_basic_block
      end

      def function(ast_func)
        visit(ast_func.block)
      end

      def block(b)
        b.statements.each {|stmt| visit(stmt)}
      end

      def statement_return(stmt)
        expr = stmt.expr
        #if expr
        #  expr = ExprVisitor.new.visit(expr)
        #end
        @basic_block.add_return(expr)
      end
    end
  end
end
