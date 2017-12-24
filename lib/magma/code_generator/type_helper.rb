module Magma
  class CodeGenerator
    module TypeHelper
      def self.llvm(type)
        case type.kind
        when :void
          LLVM.Void
        when :int
          LLVM.const_get("Int#{type.bits}")
        when :float
          case type.bits
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

      def self.value(type, value)
        t = llvm(type)
        case type.kind
        when :void
          nil
        when :int
          t.from_i(value)
        when :float
          t.from_f(value)
        when :bool
          t.from_i(value ? 1 : 0)
        end
      end

      def self.cast(basic_block, src_type, dst_type, value)
        basic_block.build do |builder|
          if src_type == dst_type
            return value
          else
            dst_llvm = llvm(dst_type)
            case [src_type.kind, dst_type.kind]
            when [:float, :float]
              return builder.fp_cast(value, dst_llvm)
            when [:float, :int]
              if dst_type.signed
                return builder.fp2si(value, dst_llvm)
              else
                return builder.fp2ui(value, dst_llvm)
              end
            when [:float, :bool]
              return builder.fp2ui(value, dst_llvm)
            when [:int, :float]
              if src_type.signed
                return builder.si2fp(value, dst_llvm)
              else
                return builder.ui2fp(value, dst_llvm)
              end
            when [:int, :int]
              if dst_type.bits <= src_type.bits
                return builder.int_cast(value, dst_llvm)
              elsif src_type.signed
                return builder.sext(value, dst_llvm)
              else
                return builder.zext(value, dst_llvm)
              end
            when [:int, :bool]
              return builder.int_cast(value, dst_llvm)
            when [:bool, :int]
              return builder.zext(value, dst_llvm)
            else
              return builder.int_cast(value, dst_llvm)
            end
          end
        end
      end
    end
  end
end
