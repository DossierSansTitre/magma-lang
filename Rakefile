$:.unshift File.realpath(File.join(File.dirname(__FILE__), 'lib'))
require 'magma/compiler_driver'

task default: %w[build:runtime]

task 'build:runtime' do
  rt = "libexec/magma_rt.S"
  rt_out = "libexec/magma_rt.o"
  cc = Magma::CompilerDriver.new
  cc.compile([rt], rt_out, object: true)
end
