module Magma
  class SourceLoc
    attr_reader :file
    attr_reader :line
    attr_reader :column

    def initialize(file, line, column)
      @file = file
      @line = line
      @column = column
    end

    def filename
      @file.name
    end

    def text
      @file.lines[@line]
    end

    def to_s
      "#{@file.name}:#{@line + 1}:#{@column + 1}"
    end

    def inspect
      to_s
    end
  end
end
