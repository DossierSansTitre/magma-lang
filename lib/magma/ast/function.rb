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

      def add_param(param)
        @params << param
      end

      def children
        [@block].reject(&:nil?)
      end

      def dump(indent)
        super(indent, "#{@name} -> #{@type}")
      end

      def generate(mod, generate_body)
        f = nil
        if generate_body
          f = mod.functions[mangled_name]
        else
          f = mod.functions.add(mangled_name, [LLVM::Int] * @params.length, LLVM::Int)
          f.params.each_with_index do |p, i|
            name = @params[i].str
            p.name = name
          end
        end
        if @block && generate_body
          b = f.basic_blocks.append
          f.params.each do |p|
            b.build do |builder|
              alloc = builder.alloca(p)
              builder.store(p, alloc)
              $named_values[p.name] = alloc
            end
          end
          @block.generate(mod, b)
        end
        f
      end

      def mangled_name
        Support::NameMangler.function(@name)
      end
    end
  end
end
