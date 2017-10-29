module Magma
  module AST
    class Variable
      attr_reader :name
      attr_reader :type
      attr_accessor :value

      def initialize(name, type, value)
        @name = name
        @type = type
        @value = value
      end
    end
  end
end
