module Magma
  module AST
    class Node 
      def children
        []
      end

      def inspect
        dump
      end

      def dump(indent = 0, value = nil)
        value = value.nil? ? "" : "(#{value})"
        (" " * indent) + self.class.name.split('::').last + value + "\n" + children.map{|n| n.dump(indent + 1)}.join("\n")
      end
    end
  end
end
