require 'logger'

%w(
    rules
    engine
    aggregate
    aggregates_array
    array
    version
  ).each { |file| require File.join(File.dirname(__FILE__), 'aggrego', file) }

module Aggrego
  # Your code goes here...
  LOGGER_LEVEL = Logger::INFO
end

# class Array
#   include Aggrego::Array
# end
