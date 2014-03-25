# Aggrego

Given a set of zones (or whatever you want) like

    north, north_central, south_central, south, priolo

i would like to express these zones in a more succinct mode, like

    continent and priolo

or (for another example)

    italy except priolo
      
using a set of rules that define the rules of aggregation.

## Installation

Add this line to your application's Gemfile:

    gem 'aggrego'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aggrego

## Usage

Start by defining how the macrozones are composed:

```ruby
rules = Rules.new
rules.add_rule(:m_sici, %w(prgp sici))
```
Means that the macrozone `:m_sici is` composed by two zones: `:prgp` and `:sici`.
And so on:

```ruby
rules.add_rule(:m_nord, [:nord])
rules.add_rule(:m_sud, [:cnor, :csud, :fogn, :brnn, :sud, :rosn])
rules.add_rule(:m_isole, [:sard, :prgp, :sici])
rules.add_rule(:m_conti, [:nord, :cnor, :csud, :sud, :fogn, :brnn, :rosn))
rules.add_rule(:m_italia, [:nord, :cnor, :csud, :sud, :fogn, :brnn, :rosn, :sici, :prgp, :sard])
```

These rules are applied to your set of zones through an order you can set automatically:
```ruby
rules.auto_sort! # the rules are sorted from the largest (in terms of number of zones) to smallest
```
or manually:
```ruby
rules.sort!([:m_italia, :m_conti, :m_sud, :m_isole, :m_sici, :m_nord])
```

Then define the engine that will perform the aggregation and pass the rules object:
```ruby
e = Engine.new(rules)
```

Now simply call the aggregate method passing a list of zones:
```ruby
results = e.aggregate(:cnor, :csud, :sud, :sici, :sard, :prgp, :brnn, :fogn, :rosn)
```

The `results` is an object of class `AggregatesArray` (a subclass of `Array`), where the elements are objects of class `Aggregate` ordered by a score.

You just have to pick the `first` or the `best`:

```ruby
result = results.best
puts result.to_s
```





## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


```ruby

```
