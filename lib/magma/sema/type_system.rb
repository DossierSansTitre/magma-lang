require 'magma/type'

module Magma
  module Sema
    class TypeSystem
      def initialize
        @types = {}
        add_builtin_types
      end

      def get(type)
        @types[type]
      end

      def [](type)
        get(type)
      end

      def add(type)
        @types[type.name] = type
      end

      def alias_type(name, type)
        if type.is_a?(String)
          type = @types[type]
        end
        @types[name] = type
      end

      private
      def add_builtin_types
        Type::BUILTIN.each {|t| add(t)}

        alias_type("Int", "Int64")
        alias_type("UInt", "UInt64")
        alias_type("Float", "Float32")
        alias_type("Double", "Float64")
        alias_type("Byte", "UInt8")
        alias_type("Bit", "Bool")
      end
    end
  end
end
