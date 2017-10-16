module Magma
  class TokenString < Token
    attr_reader :str

    def initialize(type, str)
      super(type)
      @str = str
    end
  end
end
