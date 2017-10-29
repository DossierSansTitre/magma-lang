module Magma
  module Support
    class CodegenContext
      attr_accessor :ast
      attr_accessor :module
      attr_accessor :function
      attr_accessor :block
      attr_accessor :llvm_block
      attr_accessor :builder

      def initialize(parent = nil)
        @parent = parent
        @ast = nil
        @module = nil
        @function = nil
        @block = nil
        @llvm_block = nil
        @builder = nil
      end
    end
  end
end
