require 'magma/ast'

module Magma
  class Parser
    attr_reader :tokens

    OPERATORS = {
      :add  => :tplus,
      :sub  => :tminus,
      :mul  => :tmul,
      :div  => :tdiv,
      :mod  => :tmod,
      :eq   => :teq,
      :ne   => :tne,
      :gt   => :tgt,
      :ge   => :tge,
      :lt   => :tlt,
      :le   => :tle,
      :lor  => :tlor,
      :land => :tland,
      :or   => :tor,
      :and  => :tand,
      :xor  => :txor,
      :lshift => :tlshift,
      :rshift => :trshift,
      :plus   => :tplus,
      :minus  => :tminus,
      :lnot   => :tbang,
      :not    => :ttilde
    }

    def initialize(scanner, reporter)
      @scanner = scanner
      @reporter = reporter
      @ast = AST::Root.new
      @tokens = []
      @index = 0
      @save = []
    end

    def parse
      loop do
        node = nil
        if (node = parse_function)
          @ast.add_function(node)
          next
        end
        t = pop_token
        unless t.nil?
          @reporter.error("Unexpected token, expected EOF", t.source_loc)
        end
        break
      end
      @ast
    end

    private
    def push_token
      @index -= 1
    end

    def pop_token
      if @index >= @tokens.size
        @tokens.push(@scanner.next_token)
      end
      t = @tokens[@index]
      @index += 1
      t
    end

    def accept(type)
      t = pop_token
      return if t.nil?
      return t if t.type == type
      push_token
      nil
    end

    def save
      @save.push(@index)
    end

    def restore
      @index = @save.pop
    end

    def commit
      @save.pop
    end

    def parse_block
      save
      lparen = accept(:tlbrace)
      if lparen.nil?
        restore
        return
      end
      block = AST::Block.new
      loop do
        statement = parse_statement
        break if statement.nil?
        block.add_statement(statement)
      end
      rparen = accept(:trbrace)
      if rparen.nil?
        restore
        return
      end
      commit
      block
    end

    def parse_function
      save
      unless accept(:kfun)
        restore
        return
      end
      id = accept(:identifier)
      if id.nil?
        restore
        return
      end
      unless accept(:tlparen)
        restore
        return
      end
      function = AST::Function.new(id.str)
      loop do
        i = accept(:identifier)
        break if i.nil?
        accept(:tcolon)
        t = accept(:identifier)
        function.add_param(AST::FunctionParam.new(i.str, t.str))
        break unless accept(:tcomma)
      end
      unless accept(:trparen)
        restore
        return
      end
      if accept(:tarrow)
        type = accept(:identifier)
        function.type = type.str
      end
      b = parse_block
      if b.nil?
        restore
        return
      end
      commit
      function.block = b
      function
    end

    def parse_statement
      statement = nil
      statement ||= parse_statement_variable
      statement ||= parse_statement_return
      statement ||= parse_statement_expr
      statement
    end

    def parse_statement_variable
      save
      unless accept(:kvar)
        restore
        return
      end
      name = accept(:identifier)
      unless accept(:tcolon)
        restore
        return
      end
      type = accept(:identifier)
      unless accept(:tsemicolon)
        restore
        return
      end
      commit
      return AST::StatementVariable.new(name.str, type.str)
    end

    def parse_statement_expr
      e = parse_expr
      return if e.nil?
      save
      unless accept(:tsemicolon)
        restore
        return
      end
      commit
      AST::StatementExpr.new(e)
    end

    def parse_statement_return
      save
      unless accept(:kreturn)
        restore
        return
      end
      e = parse_expr
      unless accept(:tsemicolon)
        restore
        return
      end
      commit
      AST::StatementReturn.new(e)
    end

    def parse_expr
      parse_expr_binary_lor
    end

    def parse_expr_binary(op, next_method)
      e = self.__send__(next_method)
      return if e.nil?
      op = [op] unless op.is_a?(Array)
      loop do
        operation = nil
        op.each do |o|
          tok = OPERATORS[o]
          if accept(tok)
            operation = o
            break
          end
        end
        break if operation.nil?
        rhs = self.__send__(next_method)
        e = AST::ExprBinary.new(operation, e, rhs)
      end
      e
    end

    def parse_expr_binary_lor
      parse_expr_binary(:lor, :parse_expr_binary_land)
    end

    def parse_expr_binary_land
      parse_expr_binary(:land, :parse_expr_binary_or)
    end

    def parse_expr_binary_or
      parse_expr_binary(:or, :parse_expr_binary_xor)
    end

    def parse_expr_binary_xor
      parse_expr_binary(:xor, :parse_expr_binary_and)
    end

    def parse_expr_binary_and
      parse_expr_binary(:and, :parse_expr_binary_equal)
    end

    def parse_expr_binary_equal
      parse_expr_binary([:eq, :ne], :parse_expr_binary_greater)
    end

    def parse_expr_binary_greater
      parse_expr_binary([:gt, :ge, :lt, :le], :parse_expr_binary_shift)
    end

    def parse_expr_binary_shift
      parse_expr_binary([:rshift, :lshift], :parse_expr_binary_add)
    end

    def parse_expr_binary_add
      parse_expr_binary([:add, :sub], :parse_expr_binary_mul)
    end

    def parse_expr_binary_mul
      parse_expr_binary([:mul, :div, :mod], :parse_expr_unary)
    end

    def parse_expr_unary
      op = nil
      [:plus, :minus, :lnot, :not].each do |o|
        tok = OPERATORS[o]
        if accept(tok)
          op = o
          break
        end
      end
      if op
        expr = parse_expr_unary
        AST::ExprUnary.new(op, expr)
      else
        parse_expr_primary
      end
    end

    def parse_expr_primary
      expr = nil
      expr ||= parse_expr_paren
      expr ||= parse_expr_assign
      expr ||= parse_expr_call
      expr ||= parse_expr_literal
      expr ||= parse_expr_identifier
      expr
    end

    def parse_expr_paren
      save
      unless accept(:tlparen)
        restore
        return
      end
      e = parse_expr
      accept(:trparen)
      commit
      e
    end

    def parse_expr_assign
      save
      name = accept(:identifier)
      if name.nil?
        restore
        return
      end
      unless accept(:tassign)
        restore
        return
      end
      expr = parse_expr
      if expr.nil?
        restore
        return
      end
      commit
      AST::ExprAssign.new(name.str, expr)
    end

    def parse_expr_call
      save
      id = accept(:identifier)
      if id.nil?
        restore
        return
      end
      unless accept(:tlparen)
        restore
        return
      end
      call = AST::ExprCall.new(id.str)
      loop do
        e = parse_expr
        break if e.nil?
        call.add_argument(e)
        break unless accept(:tcomma)
      end
      unless accept(:trparen)
        restore
        return
      end
      commit
      call
    end

    def parse_expr_literal
      e = nil
      e ||= parse_expr_literal_num
      e ||= parse_expr_literal_bool
      e
    end

    def parse_expr_literal_num
      save
      num = accept(:number)
      if num.nil?
        restore
        return
      end
      commit
      case num.number_type
      when :int
        AST::ExprLiteral.new("Int", num.number)
      when :unsigned_int
        AST::ExprLiteral.new("UInt", num.number)
      when :float32
        AST::ExprLiteral.new("Float32", num.number)
      when :float64
        AST::ExprLiteral.new("Float64", num.number)
      end
    end

    def parse_expr_literal_bool
      if accept(:ktrue)
        AST::ExprLiteral.new("Bool", true)
      elsif accept(:kfalse)
        AST::ExprLiteral.new("Bool", false)
      end
    end

    def parse_expr_identifier
      save
      id = accept(:identifier)
      if id.nil?
        restore
        return
      end
      commit
      AST::ExprIdentifier.new(id.str)
    end
  end
end
