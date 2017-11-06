require 'magma/compile_tree'
require 'magma/compile_tree_builder/function_decl_visitor'

module Magma
  module CompileTreeBuilder
    def self.run(ast)
      ct = CompileTree::Root.new
      build_function_decls(ct, ast)
    end

    private
    def self.build_function_decls(ct, ast)
      FunctionDeclVisitor.new(ct).visit(ast)
    end
  end
end
