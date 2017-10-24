require 'magma/ast/block'
require 'magma/support/name_mangler'

module Magma
  module AST
    class Function < Node
      attr_writer :type
      attr_writer :block

      def initialize(name)
        @name = name
        @block = nil
        @type = "Void"
        @params = []
      end

      def return_type(ast)
        ast.types[@type]
      end

      def add_param(param)
        @params << param
      end

      def children
        (@params + [@block]).reject(&:nil?)
      end

      def dump(indent)
        super(indent, "#{@name} -> #{@type}")
      end

      def generate(ast, generate_body)
        f = nil
        if generate_body
          f = ast.module.functions[mangled_name]
        else
          func_types = @params.map{|p| p.type(ast).to_llvm}
          f = ast.module.functions.add(mangled_name, func_types, return_type(ast).to_llvm)
          f.params.each_with_index do |p, i|
            p.name = @params[i].name
          end
        end
        if @block && generate_body
          f.params.each do |p|
            @block.set_variable(p.name, p)
          end
          b = f.basic_blocks.append
          @block.generate(ast, b)
        end
        f
      end

      def mangled_name
        Support::NameMangler.function(@name)
      end
    end
  end
end
