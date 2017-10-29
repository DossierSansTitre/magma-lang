require 'magma/ast/type_native'

module Magma
  class TypeSystem
    KIND_ORDER = {
      :float => 0,
      :int => 1,
      :bool => 2
    }

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

    def add_native(name, kind, bits, signed = true)
      add TypeNative.new(name, kind, bits, signed)
    end

    def result_type(a, b)
      if a == b
        return a
      end

      a, b = *([a, b].sort_by{|x| [KIND_ORDER[x.kind], x.bits]})

      if a.kind != b.kind
        if a.kind == :float
          return find_minimal(:float, a.bits)
        end
        if a.kind == :int
          return find_minimal(:int, 64, a.signed)
        end
      end

      # Now we must convert between types of the same kind but different bitsizes and signedness
      # For floats, it's easy, just take the largest
      if a.kind == :float
        return b
      end

      # For ints, it depends.
      # If both are of the same signedness, use that.
      # Else defaults to signed
      if a.signed == b.signed
        find_minimal(:int, 64, a.signed)
      else
        find_minimal(:int, 64, true)
      end
    end

    def find_minimal(kind, bits, signed = nil)
      @types.values.select { |x|
        x.kind == kind && x.bits >= bits && (signed ? x.signed == signed : true)
      }.sort { |x|
        x.bits
      }.first
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
