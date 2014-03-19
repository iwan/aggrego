# Aggrego

TODO: Write a gem description

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
Means that the macrozone :m_sici is composed by two zones: :prgp and :sici.
And so on:

```ruby
rules.add_rule(:m_nord, %w(nord))
rules.add_rule(:m_sud, %w(cnor csud fogn brnn sud rosn))
rules.add_rule(:m_isole, %w(sard prgp sici))
rules.add_rule(:m_conti, %w(nord cnor csud sud fogn brnn rosn))
rules.add_rule(:m_italia, %w(nord cnor csud sud fogn brnn rosn sici prgp sard))
```

These rules are applied to your set of zones through an order you can set automatically:
```ruby
rules.auto_sort! # the rules are sorted from the largest (in terms of number of zones) to smallest
```
or manually:
```ruby
rules.sort!([:m_italia, :m_conti, :m_sud, :m_isole, :m_sici, :m_nord])
```

Then you set up the set of zones:
```ruby
a = Aggregate.new([:cnor, :csud, :sud, :sici, :sard, :prgp, :brnn, :fogn, :rosn])
```

and your aggregator:
```ruby
a = Engine.new(rules)
r = a.fuse(aggregate)
```






## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


```ruby

```
