module Magma
  class TokenNumber < Token
    attr_reader :number

    def initialize(type, str, source_loc)
      super(type, source_loc)
      @number = str.to_i
    end

    def inspect
      super(@number.inspect)
    end
  end
end
