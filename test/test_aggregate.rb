require 'test/unit'
require 'aggrego'

class TestAggregateRules < Test::Unit::TestCase
  include Aggrego

  def test_score
    assert_equal(2, Aggregate.new(%w(a b)).score)
    assert_equal(5, Aggregate.new(%w(a b), %w(a b c)).score)
    assert_equal(10, Aggregate.new(%w(a b), %w(a b c), %w(a b c d e)).score)
    assert_equal(17, Aggregate.new(%w(a b), %w(a b c), %w(a b c d e), %w(a b c d e f g)).score)
  end

  def test_positive_match
    assert_same_aggregate(Aggregate.new([],[],[:ab],[]), Aggregate.new(%w(a b)).positive_match(:ab, %w(a b)))
    assert_same_aggregate(Aggregate.new([:c],[],[:ab],[]), Aggregate.new(%w(a b c)).positive_match(:ab, %w(a b)))
    assert_same_aggregate(Aggregate.new([],[:b],[:ab],[]), Aggregate.new(%w(a)).positive_match(:ab, %w(a b)))
    assert_nil(Aggregate.new(%w(c)).positive_match(:ab, %w(a b)))
    assert_nil(Aggregate.new(%w(a b), [:c]).positive_match(:abc, %w(a b c)))
    assert_same_aggregate(Aggregate.new([],[:c],[:ab],[]), Aggregate.new(%w(a b), [:c]).positive_match(:ab, %w(a b)))
    assert_same_aggregate(Aggregate.new([:d],[:c],[:ab],[]), Aggregate.new(%w(a b d), [:c]).positive_match(:ab, %w(a b)))
  end

  def test_negative_match
    assert_same_aggregate(Aggregate.new([:a, :b],[:f],[],[:de]), Aggregate.new(%w(a b), %w(d e f)).negative_match(:de, %w(d e)))
    assert_nil(Aggregate.new(%w(a b c)).negative_match(:ab, %w(a b)))
  end

  def assert_same_aggregate(a1, a2)
    assert(a1.equal?(a2))
  end
end