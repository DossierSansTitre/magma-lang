module Magma
  class FileBuffer
    attr_reader :name
    attr_reader :lines
    attr_reader :buffer

    def initialize(name, buffer)
      @name = name
      @lines = buffer.lines
    end

    def self.open(filename)
      FileBuffer.new(filename, File.read(filename))
    end
  end
end
