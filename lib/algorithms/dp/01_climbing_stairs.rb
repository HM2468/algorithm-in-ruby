# frozen_string_literal: true

=begin
70. Climbing Stairs

You are climbing a staircase. It takes n steps to reach the top.
Each time you can either climb 1 or 2 steps.
Return the number of distinct ways to reach the top.

Conventions (point-based DP / index-based DP):
  - n: total number of steps (1-based)
  - ways(n): number of distinct ways to reach step n

State meaning:
  ways(n) = total number of ways to reach the n-th step

Base cases:
  ways(1) = 1   # only one way: 1
  ways(2) = 2   # two ways: 1+1, 2

Transition:
  To reach step n, the last move must be:
    - from step n-1 with a 1-step move
    - from step n-2 with a 2-step move

  Therefore:
    ways(n) = ways(n-1) + ways(n-2)

This is a classic 1D dynamic programming problem and is
mathematically equivalent to the Fibonacci sequence (with shifted indices).

We provide multiple implementations:
  1) memoization    : top-down recursion with caching
  2) tabulation_1   : bottom-up DP array (O(n) space)
  3) tabulation_2   : bottom-up with rolling variables (O(1) space)

Time Complexity:
  - All implementations: O(n)

Space Complexity:
  - memoization    : O(n) recursion + O(n) cache
  - tabulation_1   : O(n)
  - tabulation_2   : O(1)

@param n [Integer]
@return [Integer]
=end

module DP
  class ClimbingStairs
    def memoization(n)
      validate_n!(n)
      return 1 if n == 1
      return 2 if n == 2

      @memo_ways ||= [nil, 1, 2]  # index: 1->1, 2->2
      return @memo_ways[n] unless @memo_ways[n].nil?

      @memo_ways[n] = memoization(n - 1) + memoization(n - 2)
    end

    # Tabulation with DP array (O(n) space)
    def tabulation_1(n)
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
    def tabulation_2(n)
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