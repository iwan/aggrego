require 'test/unit'
require 'aggrego'

class TestArray < Test::Unit::TestCase
  def setup
    @a = Aggrego::Array.new([1,2,3,4,5,6])
    @b = Aggrego::Array.new([5,6,7,8])
    @c = Aggrego::Array.new([9,10,11])
    @d = Aggrego::Array.new([0,1,2,3,4,5,6])
  end

  def test_delta
    assert_equal([[1,2,3,4],[7,8]], @a.delta(@b))
    assert_equal([[7,8],[1,2,3,4]], @b.delta(@a))
    assert_equal([@a,@c], @a.delta(@c))
    assert_equal([@c,@a], @c.delta(@a))
  end

  def test_included_id
    assert(!@a.included_in?(@b))
    assert(@a.included_in?(@a))
    assert(!Aggrego::Array.new([2,4,5,9,6,8,10,7]).included_in?(@b))
    assert(@b.included_in?([2,4,5,9,6,8,10,7]))
  end
end