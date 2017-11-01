require 'magma/source_loc'
require 'magma/token'
require 'magma/file_reader'

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

    def self.token_name(tok)
      case tok
      when nil
        return "EOF"
      when :identifier
        return "identifier"
      when :number
        return "number"
      end
      KEYWORDS.each do |k, v|
        return k if v == tok
      end
      SYMBOLS.each do |k, v|
        return k if v == tok
      end
      tok.to_s
    end

    def initialize(file_buffer, reporter)
      @reader = FileReader.new(file_buffer)
      @reporter = reporter
    end

    def next_token
      skip_ws
      tok = nil
      tok ||= scan_symbol
      tok ||= scan_identifier
      tok ||= scan_number
      if tok.nil?
        check_eof
      end
      tok
    end

    private
    def skip_ws
      @reader.scan(/[ \n\r\t\f]+/)
    end

    def scan_symbol
      SYMBOLS.each do |key, value|
        m = @reader.scan(key)
        if m
          return Token.new(value, m.source_loc)
        end
      end
      nil
    end

    def scan_identifier
      id = @reader.scan(/\A[a-zA-Z_][a-zA-Z0-9_]*/)
      if id
        KEYWORDS.each do |key, value|
          if id.str == key
            return Token.new(value, id.source_loc)
          end
        end
        return TokenString.new(:identifier, id.str, id.source_loc)
      end
      nil
    end

    def scan_number
      scan_number_float || scan_number_int
    end

    def scan_number_float
      f = @reader.scan(/\A[0-9]+\.([0-9]*f|[0-9]+)/)
      if f
        str = f.str
        type = :float64
        if str[-1] == 'f'
          type = :float32
          str = str[0..-2]
        end
        return TokenNumber.new(str.to_f, type, f.source_loc)
      end
      nil
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
      num = @reader.scan(/\A0b([0-1]+)/)
      if num
        str = num.match[1]
        return TokenNumber.new(str.to_i(2), :uint, num.source_loc)
      end
      nil
    end

    def scan_number_int_oct
      num = @reader.scan(/\A0o?([0-7]+)/)
      if num
        return TokenNumber.new(num.match[1].to_i(8), :uint, num.source_loc)
      end
      nil
    end

    def scan_number_int_hex
      num = @reader.scan(/\A0x([0-9a-fA-F]+)/)
      if num
        return TokenNumber.new(num.match[1].to_i(16), :uint, num.source_loc)
      end
      nil
    end

    def scan_number_int_dec
      num = @reader.scan(/\A(?:0d)?([0-9]+)u?/)
      if num
        type = :int
        if num.str[-1] == 'u'
          type = :uint
        end
        return TokenNumber.new(num.match[1].to_i(10), type, num.source_loc)
      end
      nil
    end

    def check_eof
      c = @reader.getc
      if c
        @reporter.error("syntax error: unknown token", c.source_loc)
      end
    end
  end
end
