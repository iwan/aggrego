require File.join(File.dirname(__FILE__), 'lib', 'aggrego')
include Aggrego

rules = Rules.new(:force_to_sym => true)
rules.add_rule(:m_nord, [:nord])
rules.add_rule(:m_sud, [:cnor, :csud, :fogn, :brnn, :sud, :rosn])
rules.add_rule(:m_isole, [:sard, :prgp, :sici])
rules.add_rule(:m_conti, [:nord, :cnor, :csud, :sud, :fogn, :brnn, :rosn])
rules.add_rule(:m_italia, [:nord, :cnor, :csud, :sud, :fogn, :brnn, :rosn, :sici, :prgp, :sard])
rules.auto_sort!


e = Engine.new(rules)

# result = e.aggregate(Aggregate.new([:cnor, :csud, :sud, :sici, :sard, :prgp, :brnn, :fogn, :rosn]))
# # or
# e.aggregate([:cnor, :csud, :sud, :sici, :sard, :prgp, :brnn, :fogn, :rosn])
# # or even
# e.aggregate(:cnor, :csud, :sud, :sici, :sard, :prgp, :brnn, :fogn, :rosn)


# will be returned an AggregatesArray


# difetti: sici, sard, priolo => Italia-Continente (invece dovrebbe essere Isole)
ag = Aggregate.new([:sici, :sard, :prgp])
result = e.aggregate(ag)
puts result.size

puts result.inspect

puts result.best.inspect