# frozen_string_literal: true

=begin
209. Minimum Size Subarray Sum

Given an array of positive integers nums and a positive integer target,
return the minimal length of a subarray whose sum is greater than or equal
to target. If there is no such subarray, return 0 instead.

A subarray is a contiguous non-empty sequence of elements.

Conventions (sliding window / two pointers):
  - Use a window [left..right] (inclusive indices)
  - Expand right pointer to increase the sum
  - Shrink left pointer while the window sum is still >= target
  - Since all numbers are positive, shrinking the window decreases the sum,
    and expanding the window increases the sum

State / invariant:
  - window_sum = sum of nums[left..right]
  - When window_sum >= target, current window is valid
  - Try shrinking to get the shortest valid window

Algorithm idea:
  - Iterate right pointer through nums
  - Add nums[right] to window_sum
  - While window_sum >= target:
      update best length
      subtract nums[left]
      move left forward

Key insight:
  - Because all numbers are positive, the window is monotonic:
      expanding makes sum larger,
      shrinking makes sum smaller
  - This property makes sliding window correct and efficient

Time complexity:
  - O(n)

Space complexity:
  - O(1)

@param target [Integer]
@param nums [Array<Integer>]
@return [Integer]
=end

module SlidingWindow
  class MinimumSizeSubarraySum
    # Sliding Window / Two Pointers
    #
    # window_sum: sum of nums[left..right]
    #
    # Invariant:
    #   when window_sum >= target, the current window is valid
    #
    # Time:  O(n)
    # Space: O(1)
    def min_sub_array_len(target, nums)
      raise ArgumentError, "target must be a positive Integer" unless target.is_a?(Integer) && target.positive?
      raise ArgumentError, "nums must be an Array" unless nums.is_a?(Array)
      raise ArgumentError, "nums must contain only positive Integers" unless nums.all? { |x| x.is_a?(Integer) && x.positive? }

      return 0 if nums.empty?

      left = 0
      window_sum = 0
      arr_len = nums.length
      best_len = arr_len + 1

      (0...arr_len).each do |right|
        window_sum += nums[right]

        while window_sum >= target
          best_len = [best_len, right - left + 1].min
          window_sum -= nums[left]
          left += 1
        end
      end

      best_len > arr_len ? 0 : best_len
    end
  end
end