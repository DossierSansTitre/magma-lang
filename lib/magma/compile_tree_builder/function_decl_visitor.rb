require 'magma/visitor'

module Magma
  module CompileTreeBuilder
    class FunctionDeclVisitor
      include Visitor

      def initialize(ct)
        @ct = ct
      end

      def root(ast)
        ast.functions.each {|f| visit(f)}
      end

      def function(f)
        params = []
        type = @ct.types[f.type]
        name = f.name
        f.params.each do |p|
          params << @ct.types[p.type_str]
        end
        @ct.add_function_decl(name, type, params)
        p @ct
      end
    end
  end
end
