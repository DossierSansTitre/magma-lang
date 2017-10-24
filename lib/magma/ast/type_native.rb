module Magma
  class TypeNative
    attr_reader :name

    def initialize(name, kind, bits, signed)
      @name = name
      @kind = kind
      @bits = bits
      @signed = signed
    end

    def to_llvm
      case @kind
      when :void
        LLVM::Void
      when :int
        LLVM.const_get("Int#{@bits}")
      when :float
        LLVM.const_get("Float#{@bits}")
      when :bool
        LLVM::Int1
      end
    end
  end
end
