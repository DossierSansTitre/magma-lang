require 'magma/compile_tree'
require 'magma/compile_tree_builder/tree_visitor'

module Magma
  module CompileTreeBuilder
    def self.run(ast)
      ct = CompileTree::Root.new
      build_function_decls(ct, ast)
      ct
    end

    private
    def self.build_function_decls(ct, ast)
      TreeVisitor.new(ct).visit(ast)
    end
  end
end
