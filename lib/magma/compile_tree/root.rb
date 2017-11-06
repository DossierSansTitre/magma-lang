require 'magma/compile_tree/node'
require 'magma/compile_tree/function_decl'

module Magma
  module CompileTree
    class Root < Node
      attr_reader :types
      attr_reader :function_decls

      def initialize
        @function_decls = {}
        @types = TypeSystem.new
      end

      def add_function_decl(name, type, arg_types)
        decl = FunctionDecl.new(name, type, arg_types)
        @function_decls[name] = decl
      end
    end
  end
end
