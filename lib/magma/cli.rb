require 'tmpdir'
require 'magma/scanner'
require 'magma/parser'
require 'magma/error_reporter'
require 'magma/driver'
require 'magma/compiler_driver'
require 'magma/file_buffer'
require 'magma/sema_builder'
require 'magma/native_compiler'
require 'magma/code_generator'

module Magma
  class CLI
    def initialize(args)
      @driver = Driver.new(args)
    end

    def exec
      filename = @driver.input.first
      if filename.nil?
        exit 1
      end
      f = FileBuffer.open(filename)
      reporter = ErrorReporter.new
      scanner = Scanner.new(f, reporter)
      parser = Parser.new(scanner, reporter)
      ast = parser.parse

      if reporter.error?
        return
      end
      ap ast
      sema = SemaBuilder.run(ast)
      mod = CodeGenerator.run(sema)
      obj_filename = nil
      if @driver.opts[:object]
        obj_filename = @driver.output
      else
        obj_filename = Dir::Tmpname.create(['magma-', '.o']) { }
      end
      nc = NativeCompiler.new(mod, obj_filename, @driver.optimize)
      nc.generate
      unless @driver.opts[:object]
        cc = CompilerDriver.new
        cc.compile([File.join(File.dirname(__FILE__), '..', '..', 'libexec', 'magma_rt.o'), obj_filename], @driver.output)
      end
    end

    def self.run(args)
      cli = new(args)
      cli.exec
    end
  end
end
