require 'magma/sema/node'
require 'magma/sema/function_decl'
require 'magma/sema/function'
require 'magma/sema/type_system'

module Magma
  module Sema
    class Root < Node
      attr_reader :types
      attr_reader :function_decls
      attr_reader :functions

      def initialize
        @decls_with_name = {}
        @function_decls = {}
        @functions = {}
        @types = TypeSystem.new
      end

      def visited(v)
        v.root(self)
      end

      def add_function_decl(name, type, arg_types)
        decl = FunctionDecl.new(name, type, arg_types)
        @function_decls[decl.mangled_name] = decl
        (@decls_with_name[name] ||= []) << decl
        decl
      end

      def add_function(decl)
        f = Function.new(decl)
        @functions[f.mangled_name] = f
      end

      def decls_with_name(name)
        @decls_with_name[name]
      end
    end
  end
end
