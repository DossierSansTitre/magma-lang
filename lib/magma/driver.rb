module Magma
  class Driver
    attr_reader :input
    attr_reader :output
    attr_reader :opts

    def initialize(args)
      @input = []
      @output = nil
      @opts = {}
      parse(args)
    end

    private
    def parse(args)
      loop do
        a = args.shift
        break if a.nil?

        if a == "-c"
          @opts[:object] = true
        elsif a == "-o"
          @output = args.shift
        else
          @input << a
        end
      end
      if @output.nil?
        if @opts[:object]
          @output = File.basename(@input.first, File.extname(@input.first)) + '.o'
        else
          @output = 'a.out'
        end
      end
    end
  end
end
