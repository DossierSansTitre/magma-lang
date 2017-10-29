require 'magma/source_loc'
require 'magma/token'

module Magma
  class Scanner
    IDENTIFIER      = /\A[a-zA-Z_][a-zA-Z0-9_]*\z/

    KEYWORDS = {
      'fun'     => :kfun,
      'return'  => :kreturn,
      'var'     => :kvar,
      'if'      => :kif,
      'else'    => :kelse,
      'while'   => :kwhile,
      'for'     => :kfor,
      'true'    => :ktrue,
      'false'   => :kfalse,
    }

    SYMBOLS = {
      '('   => :tlparen,
      ')'   => :trparen,
      '{'   => :tlbrace,
      '}'   => :trbrace,
      '->'  => :tarrow,
      ','   => :tcomma,
      ';'   => :tsemicolon,
      ':'   => :tcolon,
      '+'   => :tplus,
      '-'   => :tminus,
      '*'   => :tmul,
      '/'   => :tdiv,
      '%'   => :tmod,
      '>>'  => :trshift,
      '<<'  => :tlshift,
      '=='  => :teq,
      '!='  => :tne,
      '>='  => :tge,
      '>'   => :tgt,
      '<='  => :tle,
      '<'   => :tlt,
      '||'  => :tlor,
      '&&'  => :tland,
      '|'   => :tor,
      '&'   => :tand,
      '^'   => :txor,
      '~'   => :ttilde,
      '!'   => :tbang,
      '='   => :tassign,
    }

    def initialize(filename, stream, reporter)
      @filename = filename
      @stream = stream
      @reporter = reporter
      @rollback = []
      @line = 1
      @column = 1
    end

    def next_token
      skip_ws
      tok = nil
      tok ||= scan_symbol
      tok ||= scan_keyword
      tok ||= scan_identifier
      tok ||= scan_number
      tok
    end

    private
    def stream_getc
      @column += 1
      @rollback.shift || @stream.getc
    end

    def stream_putc(c)
      @column -= 1
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
        if c == "\n"
          @line += 1
          @column = 1
        end
        unless [" ", "\n", "\t", "\v", "\f"].include?(c)
          stream_putc c
          break
        end
      end
    end

    def scan_regex(regex)
      id = stream_getc
      unless regex =~ id
        stream_putc id
        return
      end
      loop do
        c = stream_getc
        tmp = id + c
        unless regex =~ tmp
          stream_putc c
          break
        end
        id = tmp
      end
      id
    end

    def scan_regex_prefix(prefix, regex)
      pre = stream_gets(prefix.size)
      if pre.nil?
        return
      end
      if pre != prefix
        stream_puts(pre)
        return
      end
      body = scan_regex(regex)
      if body.nil?
        stream_puts(pre)
        return
      end
      pre + body
    end

    def identifier
      scan_regex(IDENTIFIER)
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
      loc = source_loc
      k = keyword
      return if k.nil?
      Token.new(k, loc)
    end

    def scan_identifier
      loc = source_loc
      id = identifier
      return if id.nil?
      TokenString.new(:identifier, id, loc)
    end

    def scan_number
      scan_number_float || scan_number_int
    end

    def scan_number_float
      loc = source_loc
      int_part = scan_regex(/\A[0-9]+\z/)
      return if int_part.nil?
      dot = stream_getc
      if dot != '.'
        stream_putc dot unless dot.nil?
        stream_puts int_part
        return
      end
      frac_part = scan_regex(/\A([0-9]*f)|([0-9]+)\z/)
      if frac_part.nil?
        stream_putc dot
        stream_puts int_part
        return
      end
      str = int_part + '.' + frac_part
      t = :float64
      if str[-1] == 'f'
        str = str[0..-2]
        t = :float32
      end
      TokenNumber.new(str.to_f, t, loc)
    end

    def scan_number_int
      n = nil
      n ||= scan_number_int_bin
      n ||= scan_number_int_oct
      n ||= scan_number_int_hex
      n ||= scan_number_int_dec
      n
    end

    def scan_number_int_bin
      loc = source_loc
      str = scan_regex_prefix("0b", /\A[0-1]+\z/)
      return if str.nil?
      str = str[2..-1]
      TokenNumber.new(str.to_i(2), :unsigned_int, loc)
    end

    def scan_number_int_oct
      loc = source_loc
      str = scan_regex_prefix("0o", /\A[0-7]+\z/)
      str ||= scan_regex_prefix("0", /\A[0-7]+\z/)
      return if str.nil?
      p str
      if str[1] == 'o'
        str = str[2..-1]
      else
        str = str[1..-1]
      end
      TokenNumber.new(str.to_i(8), :unsigned_int, loc)
    end

    def scan_number_int_hex
      loc = source_loc
      str = scan_regex_prefix("0x", /\A[0-9a-fA-F]+\z/)
      return if str.nil?
      str = str[2..-1]
      TokenNumber.new(str.to_i(16), :unsigned_int, loc)
    end

    def scan_number_int_dec
      loc = source_loc
      str = scan_regex(/\A[0-9]+u?\z/)
      return if str.nil?
      t = :int
      if str[-1] == 'u'
        str = str[0..-2]
        t = :unsigned_int
      end
      TokenNumber.new(str.to_i(10), t, loc)
    end

    def scan_symbol
      loc = source_loc
      s = symbol
      return if s.nil?
      Token.new(s, loc)
    end

    def source_loc
      SourceLoc.new(@filename, @line, @column)
    end
  end
end
