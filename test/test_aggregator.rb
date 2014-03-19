require 'test/unit'
require 'aggrego'

class TestEngine < Test::Unit::TestCase
  include Aggrego

  def setup
    @all_zones = [:nord, :cnor, :csud, :sud, :sici, :sard, :prgp, :brnn, :fogn, :rosn]
    @rules_hash = {
      m_sici: %w(prgp sici),
      m_nord: %w(nord),
      m_sud: %w(cnor csud fogn brnn sud rosn),
      m_isole: %w(sard prgp sici),
      m_conti: %w(nord cnor csud sud fogn brnn rosn),
      m_italia: %w(nord cnor csud sud fogn brnn rosn sici prgp sard)
    }
    @rules = Rules.new
    @rules_hash.each do |macrozone, zones|
      @rules.add_rule(macrozone, zones)  
    end
    @rules.auto_sort!
    @engine = Engine.new(@rules)
  end

  def test_bumba
    assert_equal("m_italia except nord", @engine.aggregate(Aggregate.new(@all_zones-[:nord])).best.to_s)
    assert_equal("m_italia except nord and cnor", @engine.aggregate(Aggregate.new(@all_zones-[:nord, :cnor])).best.to_s)
    assert_equal("m_italia except nord, cnor and csud", @engine.aggregate(Aggregate.new(@all_zones-[:nord, :cnor, :csud])).best.to_s)
    assert_equal("m_italia except sici", @engine.aggregate(Aggregate.new(@all_zones-[:sici])).best.to_s)
    assert_equal("m_italia except m_sici", @engine.aggregate(Aggregate.new(@all_zones-[:sici, :prgp])).best.to_s)
    assert_equal("m_italia except m_isole", @engine.aggregate(Aggregate.new(@all_zones-[:sici, :prgp, :sard])).best.to_s)
    assert_equal("m_italia except m_isole and nord", @engine.aggregate(Aggregate.new(@all_zones-[:sici, :prgp, :sard, :nord])).best.to_s)
  end
end