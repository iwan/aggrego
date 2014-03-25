require 'test/unit'
require 'aggrego'

class TestRules < Test::Unit::TestCase
  include Aggrego

  def setup
    @rules = Rules.new
  end


  def test_add_rule
    assert_equal(0, @rules.size)
    # adding new rule
    @rules.add_rule(:m_isole, [:sici, :prgp, :sard])
    assert_equal(1, @rules.size)
    # adding new rule
    @rules.add_rule(:m_nord, [:nord])
    assert_equal(2, @rules.size)
    # adding previuos rule
    @rules.add_rule(:m_isole, [:sici, :prgp, :sard])
    assert_equal(2, @rules.size)
  end

  def test_add_rules
    assert_equal(0, @rules.size)
    @rules.add_rule(:r1, [:a, :b])
    assert_equal(1, @rules.size)
    @rules.add_rules({:r3 => [:a, :b, :c, :d], :r4 => [:a, :b, :c]})
    assert_equal([:r3, :r4], @rules.keys)
  end

  def test_auto_sort
    @rules.add_rule(:r1, %w(a b))
    @rules.add_rule(:r2, %w(a))
    @rules.add_rule(:r3, %w(a b c d))
    @rules.add_rule(:r4, %w(a b c))

    assert_equal([:r1, :r2, :r3, :r4], @rules.keys)
    @rules.auto_sort!
    assert_equal([:r3, :r4, :r1, :r2], @rules.keys)
  end

  def test_sort
    @rules.add_rule(:r1, %w(a b))
    @rules.add_rule(:r2, %w(a))
    @rules.add_rule(:r3, %w(a b c d))
    @rules.add_rule(:r4, %w(a b c))

    assert_equal([:r1, :r2, :r3, :r4], @rules.keys)
    @rules.sort!([:r4, :r3, :r2, :r1])
    assert_equal([:r4, :r3, :r2, :r1], @rules.keys)
  end

end