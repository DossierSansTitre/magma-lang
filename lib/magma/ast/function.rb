require 'magma/ast/node'
require 'magma/support/name_mangler'

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

      def mangled_name
        Support::NameMangler.function(@name)
      end

      def visited(v)
        v.function(self)
      end
    end
  end
end
