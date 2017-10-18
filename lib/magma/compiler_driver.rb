module Magma
  class CompilerDriver
    def initialize(name = "cc")
      @name = which(name)
    end

    def compile(input, output, opts = {})
      input = [input] unless input.is_a?(Array)
      args = input
      if opts[:object]
        args << "-c"
      end
      args += ["-o", output]
      execute(args)
    end

    private
    def which(name)
      ENV['PATH'].split(':').each do |p|
        path = File.join(p, name)
        if File.exist?(path)
          return path
        end
      end
      nil
    end

    def execute(args)
      system(@name, *args)
    end
  end
end
