=begin
746. Min Cost Climbing Stairs
You are given an integer array cost where cost[i] is the cost of ith step on a staircase. Once you pay the cost, you can either climb one or two steps.
You can either start from the step with index 0, or the step with index 1.
Return the minimum cost to reach the top of the floor.

Example 1:
Input: cost = [10,15,20]
Output: 15
Explanation: You will start at index 1.
- Pay 15 and climb two steps to reach the top.
The total cost is 15.

Example 2:
Input: cost = [1,100,1,1,1,100,1,1,100,1]
Output: 6
Explanation: You will start at index 0.
- Pay 1 and climb two steps to reach index 2.
- Pay 1 and climb two steps to reach index 4.
- Pay 1 and climb two steps to reach index 6.
- Pay 1 and climb one step to reach index 7.
- Pay 1 and climb two steps to reach index 9.
- Pay 1 and climb one step to reach the top.
The total cost is 6.

Constraints:

2 <= cost.length <= 1000
0 <= cost[i] <= 999
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