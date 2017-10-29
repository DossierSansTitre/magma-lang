require 'llvm/linker'
require 'llvm/target'

module Magma
  class TypeNative
    attr_reader :name
    attr_reader :kind
    attr_reader :bits
    attr_reader :signed

    def initialize(name, kind, bits, signed)
      @name = name
      @kind = kind
      @bits = bits
      @signed = signed
    end

    def value(v)
      case @kind
      when :void
        nil
      when :int
        to_llvm.from_i(v)
      when :float
        to_llvm.from_f(v)
      when :bool
        to_llvm.from_i(v ? 1 : 0)
      end
    end

    def to_llvm
      case @kind
      when :void
        LLVM.Void
      when :int
        LLVM.const_get("Int#{@bits}")
      when :float
        case @bits
        when 64
          LLVM::Double
        when 32
          LLVM::Float
        else
          nil
        end
      when :bool
        LLVM::Int1
      end
    end
  end
end
