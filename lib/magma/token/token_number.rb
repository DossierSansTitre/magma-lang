module Magma
  class TokenNumber < Token
    attr_reader :number
    attr_reader :number_type

    def initialize(number, number_type, source_loc)
      super(:number, source_loc)
      @number = number
      @number_type = number_type
    end

    def inspect
      super(@number.inspect)
    end
  end
end
