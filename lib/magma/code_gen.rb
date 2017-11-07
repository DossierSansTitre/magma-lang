require 'magma/code_gen/generator'

module Magma
  module CodeGen
    def self.generate(compile_tree)
      Generator.run(compile_tree)
    end
  end
end
