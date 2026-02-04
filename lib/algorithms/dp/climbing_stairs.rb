module DP
  class ClimbingStairs
    def memoization_climb(n)
      validate_n!(n)
      return 1 if n == 1
      return 2 if n == 2

      @memo_ways ||= [nil, 1, 2]  # index: 1->1, 2->2
      return @memo_ways[n] unless @memo_ways[n].nil?

      @memo_ways[n] = memoization_climb(n - 1) + memoization_climb(n - 2)
    end

    # Tabulation with DP array (O(n) space)
    def tabulation_climb_1(n)
      validate_n!(n)
      return 1 if n == 1
      return 2 if n == 2

      @tab_ways ||= [nil, 1, 2]
      start = [3, @tab_ways.length].max

      (start..n).each do |i|
        @tab_ways[i] = @tab_ways[i - 1] + @tab_ways[i - 2]
      end

      @tab_ways[n]
    end

    # Tabulation with rolling variables (O(1) space)
    def tabulation_climb_2(n)
      validate_n!(n)
      return 1 if n == 1
      return 2 if n == 2

      prev2 = 1 # ways(1)
      prev1 = 2 # ways(2)

      3.upto(n) do
        prev2, prev1 = prev1, prev1 + prev2
      end

      prev1
    end

    private

    def validate_n!(n)
      raise ArgumentError, "n must be a positive integer" unless n.is_a?(Integer) && n > 0
    end
  end
end