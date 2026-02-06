# frozen_string_literal: true

=begin
300. Longest Increasing Subsequence (LIS)

Given an integer array nums, return the length of the longest
strictly increasing subsequence.

A subsequence is derived by deleting some (or none) elements
without changing the relative order of the remaining elements.

Conventions (point-based DP, non-constant transition):
  - n = nums.length
  - nums[i] is the i-th element (0-based)
  - "strictly increasing" means nums[j] < nums[i]

State meaning (classic O(n^2) DP):
  dp[i] = length of the LIS that ends at index i (must include nums[i])

Base case:
  dp[i] >= 1 always (the subsequence [nums[i]] itself)

Transition (non-constant / scan previous states):
  for(int j = 0; j < i; j++) {
    if (nums[j] < nums[i]) {
      dp[i] = max(dp[i], dp[j] + 1);
    }
  }
  In other words:
  dp[i] = 1 + max(dp[j]) for all j in [0...i) where nums[j] < nums[i]
  If no such j exists, dp[i] = 1

Final answer:
  max(dp[i]) for i in 0..n-1

Why "non-constant transition"?
  For each i, we must scan all previous j < i to compute dp[i],
  so the transition cost is O(i), not O(1).

We provide multiple implementations:
  1) memoization : top-down dp(i) with caching (still O(n^2))
  2) tabulation  : bottom-up dp array (O(n^2))
  3) patience    : patience sorting / tails array (O(n log n)) for comparison

Time Complexity:
  - memoization : O(n^2)
  - tabulation  : O(n^2)
  - patience    : O(n log n)

Space Complexity:
  - memoization : O(n) memo + recursion stack O(n)
  - tabulation  : O(n)
  - patience    : O(n)

@param nums [Array<Integer>]
@return [Integer]
=end

module DP
  class LongestIncreasingSubsequence
    # Memoization (top-down)
    #
    # dp(i): LIS length ending at index i
    #
    # dp(i) = 1 + max(dp(j)) for all j < i with nums[j] < nums[i]
    #
    # Time:  O(n^2)
    # Space: O(n) memo + recursion stack O(n)
    def memoization(nums)
      validate_nums!(nums)
      n = nums.length
      return 0 if n == 0

      @nums = nums
      @memo = Array.new(n, nil)

      best = 0
      (0...n).each do |i|
        best = [best, dp(i)].max
      end
      best
    end

    # Tabulation (bottom-up) - classic O(n^2) DP
    #
    # dp[i] = LIS length ending at i
    #
    # Time:  O(n^2)
    # Space: O(n)
    def tabulation(nums)
      validate_nums!(nums)
      n = nums.length
      return 0 if n == 0

      dp = Array.new(n, 1) # base: dp[i] = 1
      best = 1

      (0...n).each do |i|
        (0...i).each do |j|
          next unless nums[j] < nums[i]
          dp[i] = [dp[i], dp[j] + 1].max
        end
        best = [best, dp[i]].max
      end

      best
    end

    # Patience sorting (tails) - O(n log n)
    #
    # tails[len] = the minimum possible tail value of an increasing subsequence
    #              with length (len + 1)
    #
    # For each x:
    #   find the first index k where tails[k] >= x, replace tails[k] = x
    #   if no such k, append x
    #
    # The length of tails is the LIS length.
    #
    # Time:  O(n log n)
    # Space: O(n)
    def patience(nums)
      validate_nums!(nums)
      return 0 if nums.empty?

      tails = []

      nums.each do |x|
        k = lower_bound(tails, x) # first idx with tails[idx] >= x
        if k == tails.length
          tails << x
        else
          tails[k] = x
        end
      end

      tails.length
    end

    private

    def dp(i)
      cached = @memo[i]
      return cached unless cached.nil?

      best = 1
      (0...i).each do |j|
        next unless @nums[j] < @nums[i]
        best = [best, dp(j) + 1].max
      end

      @memo[i] = best
    end

    # lower_bound: first index where arr[idx] >= target
    def lower_bound(arr, target)
      l = 0
      r = arr.length
      while l < r
        mid = (l + r) / 2
        if arr[mid] >= target
          r = mid
        else
          l = mid + 1
        end
      end
      l
    end

    def validate_nums!(nums)
      raise ArgumentError, "nums must be an Array" unless nums.is_a?(Array)
      unless nums.all? { |x| x.is_a?(Integer) }
        raise ArgumentError, "nums elements must be integers"
      end
    end
  end
end