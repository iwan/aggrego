module Aggrego

  class Engine

    def initialize(rules)
      @rules = rules
    end
    
    def aggregate(*atoms)
      atoms=atoms[0] if (atoms.size==1 && atoms[0].is_a?(Array))
      if atoms[0].is_a?(Aggrego::Aggregate)
        atoms = atoms[0]
      else
        atoms = Aggregate.new(atoms)
      end
      @candidates = AggregatesArray.new
      fuse(atoms, @rules.dup)
      @candidates
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