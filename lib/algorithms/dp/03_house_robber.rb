# frozen_string_literal: true

=begin
198. House Robber

You are a professional robber planning to rob houses along a street.
Each house has a certain amount of money stashed.
The only constraint is that you cannot rob two adjacent houses
(otherwise the alarm will be triggered).

Given an integer array nums where nums[i] is the amount of money in the i-th house,
return the maximum amount of money you can rob without alerting the police.

Conventions (point-based / index-based DP):
  - n = nums.length
  - nums[i]: money in house i (0-based)
  - Houses are arranged linearly

State meaning:
  dp[i] = maximum money that can be robbed from houses [0..i]

Base cases:
  dp[0] = nums[0]
  dp[1] = max(nums[0], nums[1])

Transition:
  At house i, you have two choices:
    1) Do not rob house i
       => total = dp[i-1]
    2) Rob house i
       => you must skip house i-1
       => total = dp[i-2] + nums[i]

  Therefore:
    dp[i] = max(dp[i-1], dp[i-2] + nums[i])

Final answer:
  dp[n-1]

We implement the optimized tabulation version using rolling variables
to achieve O(1) space complexity.

Time Complexity:
  - O(n)

Space Complexity:
  - O(1)

@param nums [Array<Integer>]
@return [Integer]
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

