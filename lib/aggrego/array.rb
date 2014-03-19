module Aggrego
  class Array < Array
    def included_in?(other)
      return false if size>other.size
      self.each{|e| return false if !other.include?(e)}
      true
    end

    def delta(other)
      [self-other, other-self]
    end

    def ==(other)
      self.size==other.size and self&other==self
    end

  end
end
