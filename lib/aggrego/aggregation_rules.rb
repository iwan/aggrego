module Aggrego
  class AggregationRules
    def initialize
      @h = {}
    end

    def add_rule(aggr_name, components)
      @h[aggr_name.to_sym] = components.map(&:to_sym)
    end

    def define_rules_order(arr)
      h = {}
      arr.each do |el|
        el = el.to_sym
        raise "Aggregate name not present!" if !@h.has_key?(el)
        h[el] = @h[el]
      end
      @h = h
    end
    
    # from bigger array to smaller
    def auto_order
      @h = Hash[@h.to_a.sort{|x,y| y[1].size <=> x[1].size}] # Hash[h.to_a.sort{|x,y| y[1].size <=> x[1].size}]
    end

    def each(&block)
      @h.each &block
    end

    def to_a
      @h.to_a
    end

    def dup
      @h.dup
    end

    def to_s
      @h
    end
  end
end