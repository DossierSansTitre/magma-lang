module Magma
  module Support
    module TypeHelper
      def self.cast(builder, src_type, dst_type, value)
        if src_type == dst_type
          value
        else
          dst_llvm = dst_type.to_llvm
          case [src_type.kind, dst_type.kind]
          when [:float, :float]
            builder.fp_cast(value, dst_llvm)
          when [:float, :int]
            if dst_type.signed
              builder.fp2si(value, dst_llvm)
            else
              builder.fp2ui(value, dst_llvm)
            end
          when [:float, :bool]
            builder.fp2ui(value, dst_llvm)
          when [:int, :float]
            if src_type.signed
              builder.si2fp(value, dst_llvm)
            else
              builder.ui2fp(value, dst_llvm)
            end
          when [:int, :int]
            builder.int_cast(value, dst_llvm)
          when [:int, :bool]
            builder.int_cast(value, dst_llvm)
          else
            builder.int_cast(value, dst_llvm)
          end
        end
      end
    end
  end
end
