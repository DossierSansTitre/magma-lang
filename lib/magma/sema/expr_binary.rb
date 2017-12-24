require 'magma/sema/node'
require 'magma/type'

module Magma
  module Sema
    class ExprBinary < Node
      KIND_ORDER = {
        :float => 0,
        :int => 1,
        :bool => 2
      }

      visited_as :expr_binary

      attr_reader :op
      attr_reader :lhs
      attr_reader :rhs

      def source_type
        if @source_type.nil?
          if %I[lor land].include?(@op)
            @source_type = Type::Bool
          else
            @source_type = ExprBinary.result_type(@lhs.type, @rhs.type)
          end
        end
        @source_type
      end

      def type
        if @type.nil?
          if %I[eq ne gt ge lt le].include?(@op)
            @type = Type::Bool
          else
            @type = source_type
          end
        end
        @type
      end

      def initialize(op, lhs, rhs)
        @op = op
        @lhs = lhs
        @rhs = rhs
      end

      def self.result_type(a, b)
        if a == b
          if a.kind == :int
            if a.signed
              return Type::Int64
            else
              return Type::UInt64
            end
          end
          return a
        end

        a, b = *([a, b].sort_by{|x| [KIND_ORDER[x.kind], x.bits]})

        if a.kind != b.kind
          if a.kind == :float
            case a.bits
            when 16
              return Type::Float16
            when 32
              return Type::Float32
            when 64
              return Type::Float64
            end
          elsif a.kind == :int
            if a.signed
              return Type::Int64
            else
              return Type::UInt64
            end
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
          if a.signed
            return Type::Int64
          else
            return Type::UInt64
          end
        else
          return Type::Int64
        end
      end
    end
  end
end
