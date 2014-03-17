module Aggrego
  class Aggregate
    def initialize(included_elements, excluded_elements=[], incl_molecules=[], excl_molecules=[])
      @incl_atoms = included_elements.map(&:to_sym)
      @excl_atoms = excluded_elements.map(&:to_sym)
      @incl_molec = incl_molecules.map(&:to_sym)
      @excl_molec = excl_molecules.map(&:to_sym)
    end

    def score
      @incl_atoms.size + @excl_atoms.size + @incl_molec.size + @excl_molec.size
    end
    
    def positive_match(molecule_name, molecule_atoms)
      puts "Entering positive_match. :#{molecule_name} => #{molecule_atoms}"
      puts "@incl_atoms: #{@incl_atoms}, @excl_atoms: #{@excl_atoms}, @incl_molec: #{@incl_molec}, @excl_molec: #{@excl_molec}"
      return nil if (@incl_atoms & molecule_atoms).empty? # nothing (no atom) to remove
      incl_atoms, excl_atoms = @incl_atoms.delta(molecule_atoms)

      # excl_atoms = molecule_atoms - @incl_atoms
      return nil if !(@excl_atoms & excl_atoms).empty? # i cannot add atoms already present in the set 'excl_atoms' (would be duplicated)
      # incl_atoms = @incl_atoms - molecule_atoms
      # return nil if @incl_atoms.size==incl_atoms.size
      incl_molec = @incl_molec.dup << molecule_name
      puts "incl_atoms: #{incl_atoms}, excl_atoms: #{excl_atoms}, incl_molec: #{incl_molec}"
      Aggregate.new(incl_atoms, excl_atoms, incl_molec, @excl_molec.dup)
    end

    def negative_match(molecule_name, molecule_atoms)
      puts "Entering negative_match. :#{molecule_name} => #{molecule_atoms}"
      puts "@incl_atoms: #{@incl_atoms}, @excl_atoms: #{@excl_atoms}, @incl_molec: #{@incl_molec}, @excl_molec: #{@excl_molec}"
      # return nil if (@excl_atoms & molecule_atoms).empty? # nothing (no atom) to remove
      return nil if !molecule_atoms.included_in?(@excl_atoms) # nothing (no atom) to remove
      excl_atoms, incl_atoms = @excl_atoms.delta(molecule_atoms)

      # incl_atoms = molecule_atoms - @excl_atoms
      return nil if !(@incl_atoms & incl_atoms).empty? # i can't add atoms already present in the set
      # excl_atoms = @excl_atoms - molecule_atoms
      excl_molec = @excl_molec.dup << molecule_name
      puts "incl_atoms: #{incl_atoms}, excl_atoms: #{excl_atoms}, excl_molec: #{excl_molec}"
      Aggregate.new(incl_atoms, excl_atoms, @incl_molec.dup, excl_molec)
    end

    def dup
      @incl_atoms.dup
      @excl_atoms.dup
      @incl_molec.dup
      @excl_molec.dup
    end
  end
end