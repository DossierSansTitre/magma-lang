module Magma
  module Visitor
    def visit(target, *args)
      target.visited(self, *args)
    end
  end
end
