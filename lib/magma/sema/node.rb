require 'magma/visitor'

module Magma
  module Sema
    class Node
      include Visitable
    end
  end
end
