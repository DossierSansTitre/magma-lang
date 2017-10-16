module Magma
  class Token
    attr_reader :type
    attr_reader :source_loc

    def initialize(type, source_loc)
      @type = type
      @source_loc = source_loc
    end

    def inspect(value = nil)
      values = []
      values << @type.inspect
      values << value unless value.nil?
      values << @source_loc.to_s
      "#{self.class.name.split('::').last}(#{values.join(', ')})"
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'token', '**', '*.rb')].each {|f| require f }
