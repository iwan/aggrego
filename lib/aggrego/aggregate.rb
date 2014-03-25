require 'logger'
module Aggrego
  class Aggregate
    FORCE_TO_SYM = true
    attr_reader :incl_atoms, :excl_atoms, :incl_molec, :excl_molec

    def initialize(incl_atoms, excl_atoms=[], incl_molec=[], excl_molec=[], rules={})
      %w(incl_atoms excl_atoms incl_molec excl_molec).each do |a|
        v = eval(a)
        v = FORCE_TO_SYM ? v.map(&:to_sym) : v
        v = Aggrego::Array.new(v) unless v.is_a?(Aggrego::Array)
        instance_variable_set("@#{a}", v)
      end
      @rules = rules
      @log = Logger.new(STDOUT)
      @log.level = Logger::INFO
    end

    def equal?(other)
      @incl_atoms==other.incl_atoms &&
        @excl_atoms==other.excl_atoms &&
        @incl_molec==other.incl_molec &&
        @excl_molec==other.excl_molec
    end

    def score
      @incl_atoms.size + @excl_atoms.size + @incl_molec.size + @excl_molec.size
    end

    def disaggregate
      arr = []
      arr += @incl_atoms
      @incl_molec.each do |mol_name|
        arr += @rules[mol_name]
      end
      arr.uniq!
      @excl_molec.each do |mol_name|
        arr -= @rules[mol_name]
      end
      arr -= @excl_atoms
      arr
    end
    
    def positive_match(molecule_name, molecule_atoms)
      molecule_atoms = Aggrego::Array.new(molecule_atoms) unless molecule_atoms.is_a?(Aggrego::Array)

      molecule_atoms.map!(&:to_sym) if FORCE_TO_SYM
      molecule_name = molecule_name.to_sym if FORCE_TO_SYM
      @rules[molecule_name] = molecule_atoms
      @log.debug "Entering positive_match. :#{molecule_name} => #{molecule_atoms}"
      @log.debug "@incl_atoms: #{@incl_atoms}, @excl_atoms: #{@excl_atoms}, @incl_molec: #{@incl_molec}, @excl_molec: #{@excl_molec}"

      return nil if (@incl_atoms & molecule_atoms).empty? # nothing (no atom) to remove
      incl_atoms, excl_atoms = @incl_atoms.delta(molecule_atoms)
      return nil if !(@excl_atoms & excl_atoms).empty? # i cannot add atoms already present in the set 'excl_atoms' (would be duplicated)
      incl_molec = @incl_molec.dup << molecule_name
      @log.debug "incl_atoms: #{incl_atoms}, excl_atoms: #{excl_atoms}, incl_molec: #{incl_molec}"
      Aggregate.new(incl_atoms, excl_atoms+@excl_atoms, incl_molec, @excl_molec.dup, @rules.dup)
    end

    def negative_match(molecule_name, molecule_atoms)
      molecule_atoms = Aggrego::Array.new(molecule_atoms) unless molecule_atoms.is_a?(Aggrego::Array)
      molecule_name = molecule_name.to_sym if FORCE_TO_SYM
      molecule_atoms.map!(&:to_sym) if FORCE_TO_SYM
      @rules[molecule_name] = molecule_atoms
      @log.debug "Entering negative_match. :#{molecule_name} => #{molecule_atoms}"
      @log.debug "@incl_atoms: #{@incl_atoms}, @excl_atoms: #{@excl_atoms}, @incl_molec: #{@incl_molec}, @excl_molec: #{@excl_molec}"
      return nil if !molecule_atoms.included_in?(@excl_atoms) # nothing (no atom) to remove
      excl_atoms, incl_atoms = @excl_atoms.delta(molecule_atoms)
      return nil if !(@incl_atoms & incl_atoms).empty? # i can't add atoms already present in the set
      excl_molec = @excl_molec.dup << molecule_name
      @log.debug "incl_atoms: #{incl_atoms}, excl_atoms: #{excl_atoms}, excl_molec: #{excl_molec}"
      Aggregate.new(incl_atoms+@incl_atoms, excl_atoms, @incl_molec.dup, excl_molec, @rules.dup)
    end

    def dup
      @incl_atoms.dup
      @excl_atoms.dup
      @incl_molec.dup
      @excl_molec.dup
    end

    def to_s
      a = @incl_molec + @incl_atoms
      return "empty" if a.empty?
      b = @excl_molec + @excl_atoms
      as = a.pop
      as = "#{a.join(', ')} and #{as}" if !a.empty?
      bs = b.pop
      bs = "#{b.join(', ')} and #{bs}" if !b.empty?
      bs.empty? ? as : "#{as} except #{bs}"
    end

    def equal_to?(string)
      a = string.split("except")
      incl = a[0]
      excl = a[1]
      incl
    end

    def <=>(other)
      if self.score==other.score
        if self.sub_score > other.sub_score
          1
        elsif self.sub_score < other.sub_score
          -1
        else
          0
        end
      elsif self.score>other.score
        1
      else
        -1
      end
    end


    def sub_score
      @incl_atoms.size*2 - @excl_atoms.size*2 + @incl_molec.size - @excl_molec.size
    end

  end
end
