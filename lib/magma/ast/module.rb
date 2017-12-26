require 'magma/ast/node'

module Magma
  module AST
    class Module < Node
      attr_reader :name
      attr_reader :functions
      attr_reader :modules

      def initialize(name)
        @name = name
        @functions = []
        @modules = []
      end

      def add_function(fun)
        @functions << fun
      end

      def add_module(mod)
        @modules << mod
      end

      def function(name)
        @functions.select{|x| x.name == name}.first
      end

      def children
        @modules + @functions
      end
    end
  end
end
