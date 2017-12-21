require 'magma/code_gen/generator'

module Magma
  module CodeGen
    def self.generate(sema)
      Generator.run(sema)
    end
  end
end
