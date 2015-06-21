module Bet
  module Staking
    class << self
      def dutch(prices, risk = 1)
        denom = prices.combination(2).map{ |c| c.reduce(:*) }.reduce(:+)

        stakes = prices.map.with_index do |p, i|
          (prices.dup.tap{ |a| a.delete_at(i) }.reduce(:*) * risk)
            .fdiv(denom)
            .round(2)
        end

        profits     = prices.zip(stakes).map{ |c| c.reduce(:*) }
        total_stake = stakes.reduce(:+)
        min_profit  = profits.min - total_stake

        {
          stakes: stakes,
          min_profit: min_profit,
          total_stake: total_stake,
          profitable: min_profit > 0
        }
      end
    end
  end
end