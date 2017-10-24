require 'magma/ast/type_native'

module Magma
  class TypeSystem
    def initialize
      @types = {}
      add_builtin_types
    end

    def [](type)
      @types[type]
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

    def add_native(name, kind, bits, signed = true)
      add TypeNative.new(name, kind, bits, signed)
    end

    private
    def add_builtin_types
      add_native("Void", :void, 0)

      add_native("Bool", :bool, 1)

      add_native("Int8",  :int, 8,  true)
      add_native("Int16", :int, 16, true)
      add_native("Int32", :int, 32, true)
      add_native("Int64", :int, 64, true)

      add_native("UInt8",  :int, 8,  false)
      add_native("UInt16", :int, 16, false)
      add_native("UInt32", :int, 32, false)
      add_native("UInt64", :int, 64, false)

      add_native("Float16", :float, 16)
      add_native("Float32", :float, 32)
      add_native("Float64", :float, 64)

      alias_type("Int", "Int64")
      alias_type("UInt", "UInt64")
      alias_type("Float", "Float32")
      alias_type("Double", "Float64")
      alias_type("Byte", "UInt8")
      alias_type("Bit", "Bool")
    end
  end
end
