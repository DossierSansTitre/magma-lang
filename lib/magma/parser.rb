require 'magma/ast'

module Magma
  class Parser
    def initialize(scanner)
      @scanner = scanner
      @ast = AST::Root.new
      @rollback = []
      @save = [[]]
    end

    def parse
      loop do
        node = nil
        if (node = parse_function)
          @ast.add_function(node)
          next
        end
        break
      end
      @ast
    end

    private
    def push_token(tok)
      @rollback.unshift(tok)
    end

    def pop_token
      t = @rollback.shift || @scanner.next_token
      @save.last.unshift(t)
      t
    end

    def accept(type)
      t = pop_token
      return if t.nil?
      return t if t.type == type
      push_token(t)
      nil
    end

    def save
      @save.push([])
    end

    def restore
      @save.last.each{|t| push_token(t)}
      commit
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
      b = parse_block
      if b.nil?
        restore
        return
      end
      commit
      AST::Function.new(id.str, b)
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
      unless accept(:trparen)
        restore
        return
      end
      commit
      AST::ExprCall.new(id.str)
    end
  end
end
