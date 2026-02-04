=begin
198. House Robber
You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed, the only constraint stopping you from robbing each of them is that adjacent houses have security systems connected and it will automatically contact the police if two adjacent houses were broken into on the same night.
Given an integer array nums representing the amount of money of each house, return the maximum amount of money you can rob tonight without alerting the police.

Example 1:
Input: nums = [1,2,3,1]
Output: 4
Explanation: Rob house 1 (money = 1) and then rob house 3 (money = 3).
Total amount you can rob = 1 + 3 = 4.

Example 2:
Input: nums = [2,7,9,3,1]
Output: 12
Explanation: Rob house 1 (money = 2), rob house 3 (money = 9) and rob house 5 (money = 1).
Total amount you can rob = 2 + 9 + 1 = 12.

核心建模思路:
  走到第 i 个房子时，你只有两种选择：
	1. 不抢第 i 家
    那最优结果就是前 i-1 家的最优：dp[i-1]
	2. 抢第 i 家
    那第 i-1 家必须不抢，所以收益是：dp[i-2] + nums[i]
  因此最优是两者取 max：
    dp[i] = max(dp[i-1], dp[i-2] + nums[i])
=end

module DP
  class HouseRobber
    # Tabulation with rolling variables (O(1) space)
    def rob(nums)
      validate_nums!(nums)
      n = nums.size
      return 0 if n == 0
      return nums[0] if n == 1

      prev2 = nums[0]
      prev1 = [nums[0], nums[1]].max
      (2...n).each do |i|
        cur = [prev1, prev2 + nums[i]].max
        prev2 = prev1
        prev1 = cur
      end
      prev1
    end

    private

    def validate_nums!(nums)
      raise ArgumentError, "nums must be an array of non-negative integers" unless nums.is_a?(Array) && nums.all? { |x| x.is_a?(Integer) && x >= 0 }
    end
  end
end

