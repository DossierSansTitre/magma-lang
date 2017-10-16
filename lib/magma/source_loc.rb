module Magma
  class SourceLoc
    attr_reader :filename
    attr_reader :line
    attr_reader :column

    def initialize(filename, line, column)
      @filename = filename
      @line = line
      @column = column
    end

    def to_s
      "#{@filename}:#{@line}:#{@column}"
    end

    def inspect
      to_s
    end
  end
end
