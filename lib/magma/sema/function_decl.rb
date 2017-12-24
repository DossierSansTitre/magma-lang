require 'magma/sema/node'

module Magma
  module Sema
    class FunctionDecl < Node
      attr_reader :name
      attr_reader :type
      attr_reader :args

      def initialize(name, type, args)
        @name = name
        @type = type
        @args = args
      end

      def mangled_name
        if name == "main"
          "magma_main"
        else
          "MAGMA##{name}"
        end
      end

      def visited(v)
        v.function_decl(self)
      end
    end
  end
end
