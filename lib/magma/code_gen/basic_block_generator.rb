module Magma
  module CodeGen
    class BasicBlockGenerator
      include Visitor

      def initialize(block_table)
        @block_table = block_table
      end

      def basic_block(bb)
        @basic_block = @block_table[bb.id]
        bb.statements.each {|x| visit(x)}
      end

      def statement_return(stmt)
        @basic_block.build do |builder|
          builder.ret(nil)
        end
      end
    end
  end
end
