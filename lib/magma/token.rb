module Magma
  class Token
    attr_reader :type

    def initialize(type)
      @type = type
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'token', '**', '*.rb')].each {|f| require f }
