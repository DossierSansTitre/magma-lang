require 'magma/ast'

module Magma
  class Parser
    attr_reader :tokens

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
      unless accept(:tlparen) && accept(:trparen)
        restore
        return
      end
      function = AST::Function.new(id.str)
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
      statement ||= parse_statement_expr
      statement
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

    def parse_expr
      expr = nil
      expr ||= parse_expr_call
      expr
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
  end
end
