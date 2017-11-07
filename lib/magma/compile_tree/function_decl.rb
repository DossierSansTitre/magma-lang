require 'magma/compile_tree/node'

module Magma
  module CompileTree
    class FunctionDecl < Node
      attr_reader :name
      attr_reader :type
      attr_reader :args

      def initialize(name, type, args)
        @name = name
        @type = type
        @args = args
      end

      def visited(v)
        v.function_decl(self)
      end
    end
  end
end
