require 'magma/visitor'
require 'magma/compile_tree_builder/function_visitor.rb'

module Magma
  module CompileTreeBuilder
    class TreeVisitor
      include Visitor

      class Pair
        attr_reader :ast_node
        attr_reader :ct_node

        def initialize(ast_node, ct_node)
          @ast_node = ast_node
          @ct_node = ct_node
        end
      end

      def initialize(ct)
        @ct = ct
        @functions = []
      end

      def root(ast)
        ast.functions.each {|f| visit(f)}
        @functions.each do |pair|
          FunctionVisitor.new(@ct, pair.ct_node).visit(pair.ast_node)
        end
      end

      def function(f)
        params = []
        type = @ct.types[f.type]
        name = f.name
        f.params.each do |p|
          params << @ct.types[p.type_str]
        end
        decl = @ct.add_function_decl(name, type, params)
        if f.block
          ct_fun = @ct.add_function(decl)
          @functions << Pair.new(f, ct_fun)
        end
      end
    end
  end
end
