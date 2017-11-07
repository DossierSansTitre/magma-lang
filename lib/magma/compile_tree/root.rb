require 'magma/compile_tree/node'
require 'magma/compile_tree/function_decl'
require 'magma/compile_tree/function'

module Magma
  module CompileTree
    class Root < Node
      attr_reader :types
      attr_reader :function_decls
      attr_reader :functions

      def initialize
        @function_decls = {}
        @functions = {}
        @types = TypeSystem.new
      end

      def visited(v)
        v.root(self)
      end

      def add_function_decl(name, type, arg_types)
        decl = FunctionDecl.new(name, type, arg_types)
        @function_decls[name] = decl
      end

      def add_function(decl)
        f = Function.new(decl)
        @functions[f.name] = f
      end
    end
  end
end
