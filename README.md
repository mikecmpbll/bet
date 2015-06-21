# Bet

Want to prototype a new betting strategy? Can't be arsed to work out all the annoying maths involved in calculating bets? This is the gem for you ..

## Installation

    $ gem install bet

## Usage

Possible bet types:

```ruby
# types of acca
Bet::Calc.single # 1 bet
Bet::Calc.double # 2 bet acca
Bet::Calc.treble # 3 bet acca
Bet::Calc.accumulator # any number of bets, aliased as acca, parlay

# types of full cover without single bets
Bet::Calc.trixie # 3 selections (4 bets)
Bet::Calc.yankee # 4 selections (11 bets)
Bet::Calc.canadian # 5 selections (26 bets)
Bet::Calc.heinz # 6 selections (57 bets)
Bet::Calc.super_heinz # 7 selections (120 bets)
Bet::Calc.goliath # 8 selections (247 bets)
Bet::Calc.block # 9 selections (502 bets)
Bet::Calc.full_cover(prices, min_size: 2)

# types of complete full cover (inc. singles)
Bet::Calc.patent # 3 selections (7 bets)
Bet::Calc.lucky15 # 4 selections (15 bets)
Bet::Calc.lucky31 # 5 selections (31 bets)
Bet::Calc.lucky63 # 6 selections (63 bets)
Bet::Calc.super_heinz_with_singles # 7 selections (127 bets)
Bet::Calc.goliath_with_singles # 8 selections (235 bets)
Bet::Calc.block_with_singles # 9 selections (511 bets)
Bet::Calc.full_cover(prices, min_size: 1) # 1 is default, option can be omitted
```

Some examples of bet calculations for you good folks:

```ruby
# you can provide an array of winning prices, or a results hash of
# price and win/price/loss representation, here's array format:
Bet::Calc.single(1.2) # or .single([1.2])
# => {:returns=>1.2, :profit=>0.19999999999999996, :outlay=>1}
# you'll notice the float imprecision, if you want accurate floating
# point calculations use BigDecimal:
require 'bigdecimal'
Bet::Calc.single(BigDecimal.new('1.2'))[:profit].to_f
# => 0.2

Bet::Calc.double([1.2, 5.3])
# => {:returns=>6.359999999999999, :profit=>5.359999999999999, :outlay=>1}

# etc! here's the results hash format. you can use numerical or the
# symbolic format for the win/place/loss result
{ -1 => :loss, 0 => :place, 1 => :win }

# format is price => result
Bet::Calc.yankee({ 2.3 => :win, 1.2 => :place, 4.5 => :loss, 11.0 => :win })
# => {:returns=>25.299999999999997, :profit=>14.299999999999997, :outlay=>11}

# the default stake per bet is 1, you can change this with the
# `stake` option.
Bet::Calc.yankee({ 2.3 => :win, 1.2 => :place, 4.5 => :loss, 11.0 => :win }, stake: 0.45)
# => {:returns=>11.385, :profit=>6.435, :outlay=>4.95}
```

We can also calculate the stakes for more advanced bets:

```ruby
# dutching is pretty fun, if you don't know what it is go look it up
# but this is how you calculate your stakes:
Bet::Staking.dutch([4.8, 5.3, 12], 100)
# => {
#   :stakes=>[43.37, 39.28, 17.35],
#   :min_profit=>108.17599999999999,
#   :total_stake=>100.0,
#   :profitable=>true
# }

# The first argument is the prices of the runners, the second is the
# target total stake. The `stakes` in the resulting hash are the
# stakes for each of the inputted prices (respectively). The rest
# should be fairly self explanatory.
```

## Todo

1. Implement each way bets properly
2. Write tests

## Contributing

1. Fork it ( https://github.com/mikecmpbll/bet/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
