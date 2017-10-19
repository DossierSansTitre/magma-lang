require 'magma/ast/node'
require 'magma/support/name_mangler'

module Magma
  module AST
    class ExprCall < Node
      def initialize(func_name)
        @func_name = func_name
        @arguments = []
      end

      def add_argument(arg)
        @arguments << arg
      end

      def children
        @arguments
      end

      def dump(indent = 0)
        super(indent, @func_name)
      end

      def generate(mod, builder)
        args = @arguments.map{ |a| a.generate(mod, builder) }
        builder.call(mod.functions[Support::NameMangler.function(@func_name)], *args)
      end
    end
  end
end
