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
      rparen = accept(:trbrace)
      if rparen.nil?
        restore
        return
      end
      commit
      AST::Block.new
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
  end
end
