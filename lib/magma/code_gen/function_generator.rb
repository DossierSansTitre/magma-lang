require 'magma/code_gen/basic_block_generator'

module Magma
  module CodeGen
    class FunctionGenerator
      include Visitor

      def initialize(mod)
        @module = mod
        @block_table = {}
      end

      def function(f)
        @function = @module.functions[f.name]
        f.basic_blocks.each {|x| visit(x)}
        f.basic_blocks.each {|x| BasicBlockGenerator.new(@block_table).visit(x)}
      end

      def basic_block(bb)
        @block_table[bb.id] = @function.basic_blocks.append
      end
    end
  end
end
