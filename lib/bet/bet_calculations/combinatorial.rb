module Bet
  module BetCalculations
    module Combinatorial
      {
        trixie: 3,
        yankee: 4,
        canadian: 5,
        heinz: 6,
        super_heinz: 7,
        goliath: 8,
        block: 9
      }.each do |ord, n|
        define_method(ord) do |opts|
          prices = extract_prices(opts)
          raise ArgumentError, "Wrong number of prices (#{prices.size} for #{n})" if prices.size != n
          opts[:min_size] = 2
          full_cover(opts)
        end
      end

      {
        patent: 3,
        lucky15: 4,
        lucky31: 5,
        lucky63: 6,
        super_heinz_with_singles: 7,
        goliath_with_singles: 8,
        block_with_singles: 9
      }.each do |ord, n|
        define_method(ord) do |opts|
          prices = extract_prices(opts)
          raise ArgumentError, "Wrong number of prices (#{prices.size} for #{n})" if prices.size != n
          full_cover(opts)
        end
      end 

      def full_cover(opts)
        prices = extract_prices(opts)
        opts   = parse_opts(opts)
        opts   = { min_size: 1 }.merge(opts)

        num_bets = 0
        returns = (opts[:min_size]..opts[:prices].length).to_a.map do |n|
          win_prices.combination(n).map do |multis|
            num_bets += 1
            acca(stake: opts[:stake], prices: multis)
          end.reduce(:+)
        end.reduce(:+)

        total_stake = num_bets * stake
        profit = returns - total_stake

        [returns, profit, total_stake]
      end
    end
  end
end