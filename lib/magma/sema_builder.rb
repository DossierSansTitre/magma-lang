require 'magma/sema'
require 'magma/sema_builder/tree_visitor'

module Magma
  module SemaBuilder
    def self.run(ast)
      ct = Sema::Root.new
      build_function_decls(ct, ast)
      ct
    end

    private
    def self.build_function_decls(ct, ast)
      TreeVisitor.new(ct).visit(ast)
    end
  end
end
