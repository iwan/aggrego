%w(
    aggregate
    aggregation_rules
    aggregator
    array
    version
  ).each { |file| require File.join(File.dirname(__FILE__), 'aggrego', file) }


module Aggrego
  # Your code goes here...
  Array.extend(Aggrego::Array)
end
