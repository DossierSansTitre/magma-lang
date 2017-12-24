module Magma
  module Type
    class Native
      attr_reader :name
      attr_reader :kind
      attr_reader :bits
      attr_reader :signed

      def initialize(name, kind, bits, signed = false)
        @name = name
        @kind = kind
        @bits = bits
        @signed = signed
      end
    end
  end
end
