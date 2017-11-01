require 'strscan'
require 'magma/source_loc'

module Magma
  class FileReader
    class Match
      attr_reader :str
      attr_reader :match
      attr_reader :source_loc

      def initialize(str, match, source_loc)
        @str = str
        @match = match
        @source_loc = source_loc
      end
    end

    def initialize(file_buffer)
      @file_buffer = file_buffer
      @ss = StringScanner.new(file_buffer.lines.join)
      @line = 0
      @column = 0
    end

    def scan(pattern)
      match = nil
      if pattern.is_a?(String)
        str = @ss.peek(pattern.size)
        if str == pattern
          match = Match.new(str, nil, source_loc)
          advance(str)
          @ss.pos = @ss.pos + pattern.size
        end
      else
        m = @ss.scan(pattern)
        if m
          m = pattern.match(m)
          match = Match.new(m[0], m, source_loc)
          advance(m[0])
        end
      end
      match
    end

    def getc
      match = nil
      c = @ss.getch
      if c
        match = Match.new(c, nil, source_loc)
        advance(c)
      end
      match
    end

    def source_loc
      SourceLoc.new(@file_buffer, @line, @column)
    end

    private
    def advance(str)
      str.each_char do |c|
        if c == "\n"
          @line += 1
          @column = 0
        else
          @column += 1
        end
      end
    end
  end
end
