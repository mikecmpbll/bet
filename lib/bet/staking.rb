module Bet
  module Staking
    class << self
      def dutch(prices, risk = 1)
        denom = prices.combination(prices.size - 1).reduce(0){ |m,c| m + c.reduce(:*) }

        stakes = prices.map.with_index do |p, i|
          (prices.dup.tap{ |a| a.delete_at(i) }.reduce(:*) * risk)
            .fdiv(denom)
            .round(2)
        end

        profits     = prices.zip(stakes).map{ |c| c[0] * c[1] }
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