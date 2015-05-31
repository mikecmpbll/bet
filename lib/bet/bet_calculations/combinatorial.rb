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
          results = extract_prices(opts)
          raise ArgumentError, "Wrong number of results (#{results.size} for #{n})" if results.size != n
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
          results = extract_prices(opts)
          raise ArgumentError, "Wrong number of results (#{results.size} for #{n})" if results.size != n
          full_cover(opts)
        end
      end 

      def full_cover(opts)
        prices = extract_prices(opts)
        opts   = parse_opts(opts)
        opts   = { min_size: 1 }.merge(opts)

        num_bets = (opts[:min_size]..prices.length).to_a.map do |n|
          (1..prices.length).to_a.combination(n).to_a.length
        end.reduce(:+)

        winning_prices = if prices.is_a?(Hash)
            prices.select{ |_,v| win_place_lose?(v) == :win }.keys
          else
            prices
          end

        returns = (opts[:min_size]..winning_prices.length).to_a.map do |n|
          winning_prices.combination(n).map do |multis|
            acca(stake: opts[:stake], prices: multis)[:returns]
          end.reduce(:+)
        end.reduce(:+)

        outlay = num_bets * opts[:stake]
        profit = returns - outlay

        {
          returns: returns,
          profit: profit,
          outlay: outlay
        }
      end
    end
  end
end