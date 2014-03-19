module Aggrego
  class AggregatesArray < Array
    
    def best
      self.sort.first
    end
  end
end