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
      nil
    end
  end
end
