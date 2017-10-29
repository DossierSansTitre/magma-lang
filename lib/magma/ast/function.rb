require 'magma/ast/node'
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

      def type(ctx)
        ctx.ast.types[@type]
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

      def generate(ctx, generate_body)
        ctx.function = self
        f = nil
        if generate_body
          f = ctx.module.functions[mangled_name]
        else
          func_types = @params.map{|p| p.type(ctx).to_llvm}
          f = ctx.module.functions.add(mangled_name, func_types, type(ctx).to_llvm)
          f.params.each_with_index do |p, i|
            p.name = @params[i].name
          end
        end
        if @block && generate_body
          b = f.basic_blocks.append
          b.build do |builder|
            @params.each do |param|
              type = param.type(ctx)
              name = param.name
              llvm_param = f.params.find {|x| x.name == name}
              loc = builder.alloca(type.to_llvm, "param_#{name}")
              builder.store(llvm_param, loc)
              @block.set_variable(name, type, loc)
            end
          end
          ctx.llvm_block = b
          @block.generate(ctx)
        end
        f
      end

      def mangled_name
        Support::NameMangler.function(@name)
      end
    end
  end
end
