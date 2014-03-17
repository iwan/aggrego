module Aggrego
  class Aggregator
    def initialize(rules)
      @rules = rules
    end
    
    def fuse(atoms)
      @candidates = []
      fusz(atoms, @rules.dup)
      @candidates
    end

    private

    def fusz(aggr, rules, level=0)
      while rule = rules.shift
        mol_name, mol_atoms = rule[0], rule[1]

        if a = aggr.positive_match(mol_name, mol_atoms)
          @candidates << a
          fusz(a, rules, level-1)
        end
        if a = aggr.negative_match(mol_name, mol_atoms)
          @candidates << a
          fusz(a, rules, level-1)
        end
      end
    end
  end
end