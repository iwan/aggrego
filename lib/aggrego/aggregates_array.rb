module Aggrego
  class AggregatesArray < Array
    
    def best
      first
    end

    def sort
      AggregatesArray.new(super)
    end
  end
end