module Aggrego

  class Engine

    def initialize(rules)
      @rules = rules
    end
    
    def aggregate(*atoms)
      # e.aggregate(Aggregate.new([:cnor, :csud, :sud, :sici, :sard, :prgp, :brnn, :fogn, :rosn]))
      # ---> i get an array with only one element of type Aggregate
      # e.aggregate([:cnor, :csud, :sud, :sici, :sard, :prgp, :brnn, :fogn, :rosn])
      # ---> i get an array with only one element of type Array 
      # e.aggregate(:cnor, :csud, :sud, :sici, :sard, :prgp, :brnn, :fogn, :rosn)
      # ---> i get an array with the elements

      if atoms.size==1 && atoms[0].is_a?(Aggregate)
        atoms = atoms[0]
      elsif atoms.size==1 && (atoms[0].is_a?(::Array) || atoms[0].is_a?(Array))
        atoms = Aggregate.new(atoms[0])
      else
        atoms = Aggregate.new(atoms)
      end
      @candidates = AggregatesArray.new
      fuse(atoms, @rules.dup)
      @candidates.sort
    end

    private

    def fuse(aggr, rules, level=0)
      while rule = rules.shift
        mol_name, mol_atoms = rule[0], rule[1]

        if a = aggr.positive_match(mol_name, mol_atoms)
          @candidates << a
          fuse(a, rules, level-1)
        end
        if a = aggr.negative_match(mol_name, mol_atoms)
          @candidates << a
          fuse(a, rules, level-1)
        end
      end
    end
  end
end