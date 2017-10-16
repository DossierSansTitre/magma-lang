module Magma
  class TokenString < Token
    attr_reader :str

    def initialize(type, str, source_loc)
      super(type, source_loc)
      @str = str
    end

    def inspect
      super(@str.inspect)
    end
  end
end
