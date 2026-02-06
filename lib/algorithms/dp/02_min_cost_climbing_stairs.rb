# frozen_string_literal: true

=begin
746. Min Cost Climbing Stairs

You are given an integer array cost where cost[i] is the cost of the i-th step.
Once you pay the cost, you can either climb one or two steps.
You can start from step 0 or step 1.
Return the minimum cost to reach the top of the floor (beyond the last step).

Conventions (point-based / index-based DP):
  - n = cost.length
  - cost[i]: cost of stepping on stair i (0-based)
  - The "top" is conceptually at index n (beyond the last stair)
  - You do NOT pay cost[n]; only costs of actual stairs are counted

State meaning:
  dp[i] = minimum cost required to reach step i

Interpretation:
  Reaching step i means you have already paid cost[i].
  The final answer is min(dp[n-1], dp[n-2]), because from either of them
  you can climb to the top without extra cost.

Base cases:
  dp[0] = cost[0]
  dp[1] = cost[1]

Transition:
  To reach step i, you must come from:
    - step i-1 (1 step jump)
    - step i-2 (2 steps jump)

  Therefore:
    dp[i] = min(dp[i-1], dp[i-2]) + cost[i]

Final answer:
  min(dp[n-1], dp[n-2])

We provide multiple implementations:
  1) memoization          : top-down recursion with caching
  2) tabulation_min_cost_1: bottom-up DP array (O(n) space)
  3) tabulation_min_cost_2: bottom-up with rolling variables (O(1) space)

Time Complexity:
  - All implementations: O(n)

Space Complexity:
  - memoization          : O(n) recursion + O(n) cache
  - tabulation_min_cost_1: O(n)
  - tabulation_min_cost_2: O(1)

@param cost [Array<Numeric>]
@return [Numeric]
=end

module DP
  class MinCostClimbingStairs
    # Memoization (top-down)
    def memoization_min_cost(cost)
      validate_cost!(cost)
      n = cost.length
      return 0 if n == 0
      return cost[0] if n == 1
      return [cost[0], cost[1]].min if n == 2

      # reset per call (avoid cross-input cache pollution)
      @memo_cost = []
      @memo_cost[0] = cost[0]
      @memo_cost[1] = cost[1]

      [dp(cost, n - 1), dp(cost, n - 2)].min
    end

    # Tabulation with DP array (O(n) space)
    def tabulation_min_cost_1(cost)
      validate_cost!(cost)
      n = cost.length
      return 0 if n == 0
      return cost[0] if n == 1
      return [cost[0], cost[1]].min if n == 2

      # reset per call (avoid cross-input cache pollution)
      @tab_cost = []
      @tab_cost[0] = cost[0]
      @tab_cost[1] = cost[1]

      (2...n).each do |i|
        @tab_cost[i] = [@tab_cost[i - 1], @tab_cost[i - 2]].min + cost[i]
      end

      [@tab_cost[n - 1], @tab_cost[n - 2]].min
    end

    # Tabulation with rolling variables (O(1) space)
    def tabulation_min_cost_2(cost)
      validate_cost!(cost)
      n = cost.length
      return 0 if n == 0
      return cost[0] if n == 1
      return [cost[0], cost[1]].min if n == 2

      prev2 = cost[0] # dp[0]
      prev1 = cost[1] # dp[1]

      (2...n).each do |i|
        cur = [prev1, prev2].min + cost[i]
        prev2 = prev1
        prev1 = cur
      end

      [prev1, prev2].min
    end

    private

    def validate_cost!(cost)
      raise ArgumentError, "cost must be an Array" unless cost.is_a?(Array)
      unless cost.all? { |x| x.is_a?(Numeric) && x >= 0 }
        raise ArgumentError, "cost elements must be non-negative numbers"
      end
    end

    def dp(cost, i)
      return @memo_cost[i] unless @memo_cost[i].nil?

      @memo_cost[i] = [dp(cost, i - 1), dp(cost, i - 2)].min + cost[i]
    end
  end
end