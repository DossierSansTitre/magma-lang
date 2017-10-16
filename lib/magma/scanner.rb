require 'magma/token'

module Magma
  class Scanner
    IDENTIFIER = /\A[a-zA-Z_][a-zA-Z0-9_]*\z/

    KEYWORDS = {
      'fun' => :kfun
    }

    SYMBOLS = {
      '('   => :tlparen,
      ')'   => :trparen,
      '{'   => :tlbrace,
      '}'   => :trbrace,
      '->'  => :tarrow
    }

    def initialize(stream)
      @stream = stream
      @rollback = []
    end

    def next_token
      skip_ws
      tok = nil
      tok ||= scan_symbol
      tok ||= scan_keyword
      tok ||= scan_identifier
      tok
    end

    private
    def stream_getc
      @rollback.shift || @stream.getc
    end

    def stream_putc(c)
      @rollback.unshift c
    end

    def stream_gets(size)
      buf = ""
      size.times do
        c = stream_getc
        if c.nil?
          stream_puts buf
          return nil
        end
        buf << c
      end
      buf
    end

    def stream_puts(str)
      str.reverse.each_char {|c| stream_putc c}
    end

    def skip_ws
      loop do
        c = stream_getc
        unless [" ", "\n", "\t", "\v", "\f"].include?(c)
          stream_putc c
          break
        end
      end
    end

    def identifier
      id = stream_getc
      unless IDENTIFIER =~ id
        stream_putc id
        return nil
      end
      loop do
        c = stream_getc
        tmp = id + c
        unless IDENTIFIER =~ tmp
          stream_putc c
          break
        end
        id = tmp
      end
      id
    end

    def keyword
      id = identifier
      return nil if id.nil?
      k = KEYWORDS[id]
      if k.nil?
        stream_puts id
        return nil
      end
      k
    end

    def symbol
      SYMBOLS.each do |key, value|
        size = key.size
        str = stream_gets(size)
        next if str.nil?
        if key != str
          stream_puts str
          next
        end
        return value
      end
      nil
    end

    def scan_keyword
      k = keyword
      return nil if k.nil?
      Token.new(k)
    end

    def scan_identifier
      id = identifier
      return nil if id.nil?
      TokenString.new(:identifier, id)
    end

    def scan_symbol
      s = symbol
      return nil if s.nil?
      Token.new(s)
    end
  end
end
