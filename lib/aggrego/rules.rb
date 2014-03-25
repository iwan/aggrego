module Aggrego

  class Rules

    def initialize(options={})
      @force_to_sym = (options[:force_to_sym]==true)
      @h = {}
    end

    def add_rule(aggr_name, components)
      aggr_name = aggr_name.to_sym if @force_to_sym
      components.map!(&:to_sym) if @force_to_sym
      @h[aggr_name] = components
    end

    def add_rules(hash)
      if @force_to_sym
        @h = Hash[hash.to_a.map{|e| [e[0].to_sym, e[1].map(&:to_sym)]}]
      else
        @h = hash
      end
    end

    def sort!(arr)
      h = {}
      arr.each do |el|
        el = el.to_sym if @force_to_sym
        raise "Aggregate name not present!" if !@h.has_key?(el)
        h[el] = @h[el]
      end
      @h = h
    end
    
    # from bigger array to smaller
    def auto_sort!
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

    def size
      @h.size
    end

    def to_s
      @h
    end

    def keys
      @h.keys
    end
  end
end