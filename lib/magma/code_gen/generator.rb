require 'llvm/analysis'
require 'magma/visitor'
require 'magma/code_gen/function_generator'

module Magma
  module CodeGen
    class Generator
      include Visitor

      def self.run(sema)
        Generator.new.visit(sema)
      end

      def root(ct)
        @ct = ct
        @module = LLVM::Module.new("Magma")
        @ct.function_decls.values.each {|x| visit(x)}
        @ct.functions.values.each {|x| FunctionGenerator.new(@module).visit(x)}
        @module.verify!
        @module
      end

      def function_decl(decl)
        @module.functions.add(decl.name, decl.args.map(&:to_llvm), decl.type.to_llvm)
      end
    end
  end
end
