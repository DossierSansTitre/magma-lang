require 'magma/ast/node'

module Magma
  module AST
    class Function < Node
      attr_accessor :type
      attr_accessor :block
      attr_reader :name
      attr_reader :params

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
        (@params + [@block]).reject(&:nil?)
      end

      def dump(indent = 0)
        super(indent, "#{@name} -> #{@type}")
      end
    end
  end
end
