require 'magma/type/native'

module Magma
  module Type
    Void = Native.new("Void", :void, 0)
    Bool = Native.new("Bool", :bool, 1)
    Int8 = Native.new("Int8", :int, 8, true)
    Int16 = Native.new("Int16", :int, 16, true)
    Int32 = Native.new("Int32", :int, 32, true)
    Int64 = Native.new("Int64", :int, 64, true)
    UInt8 = Native.new("UInt8",  :int, 8,  false)
    UInt16 = Native.new("UInt16", :int, 16, false)
    UInt32 = Native.new("UInt32", :int, 32, false)
    UInt64 = Native.new("UInt64", :int, 64, false)
    Float16 = Native.new("Float16", :float, 16)
    Float32 = Native.new("Float32", :float, 32)
    Float64 = Native.new("Float64", :float, 64)

    BUILTIN = [
      Void,
      Bool,
      Int8,
      Int16,
      Int32,
      Int64,
      UInt8,
      UInt16,
      UInt32,
      UInt64,
      Float16,
      Float32,
      Float64
    ]
  end
end
