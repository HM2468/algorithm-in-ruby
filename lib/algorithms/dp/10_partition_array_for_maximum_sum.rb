# frozen_string_literal: true

=begin
1043. Partition Array for Maximum Sum

Given an integer array arr and an integer k, partition the array into
contiguous subarrays, each of length at most k.

After partitioning, each subarray contributes:
  (max value in that subarray) * (length of that subarray)

Return the maximum sum after partitioning.

------------------------------------------------------------
Conventions (point-based DP, non-constant transition):
  - n = arr.length
  - arr[i] is the i-th element (0-based)

State meaning:
  dp[i] = maximum sum for subarray arr[0..i]

Base case:
  dp[i] >= arr[i]   (at minimum, arr[i] alone forms a partition)
  dp[-1] is treated as 0 (used implicitly)

Transition (non-constant):
  For each i, try all partition lengths len in [1..k]:
    - The partition ends at i
    - It starts at j = i - len + 1 (j >= 0)
    - max_val = max(arr[j..i])
    - candidate = dp[j-1] + max_val * len

  dp[i] = max over all valid candidates

Final answer:
  dp[n-1]

Why "non-constant transition"?
  For each i, we must iterate over up to k previous elements to
  evaluate all possible partitions ending at i.

------------------------------------------------------------
Time Complexity:
  - memoization : O(n * k)
  - tabulation  : O(n * k)

Space Complexity:
  - memoization : O(n) memo + recursion stack
  - tabulation  : O(n)

@param arr [Array<Integer>]
@param k   [Integer]
@return [Integer]
=end

module DP
  class PartitionArrayForMaximumSum
    # Memoization (top-down)
    #
    # dp(i): maximum sum for arr[0..i]
    #
    # Time:  O(n * k)
    # Space: O(n) memo + recursion stack
    def memoization(arr, k)
      validate_inputs!(arr, k)
      n = arr.length
      return 0 if n == 0

      @arr = arr
      @k   = k
      @memo = Array.new(n, nil)

      dp(n - 1)
    end

    # Tabulation (bottom-up)
    #
    # dp[i]: maximum sum for arr[0..i]
    #
    # Time:  O(n * k)
    # Space: O(n)
    def tabulation(arr, k)
      validate_inputs!(arr, k)
      n = arr.length
      return 0 if n == 0

      dp = Array.new(n, 0)

      (0...n).each do |i|
        max_val = 0

        # try all partitions ending at i, with length 1..k
        (1..k).each do |len|
          j = i - len + 1
          break if j < 0

          max_val = [max_val, arr[j]].max
          prev = (j > 0) ? dp[j - 1] : 0
          dp[i] = [dp[i], prev + max_val * len].max
        end
      end

      dp[n - 1]
    end

    private

    # dp(i): maximum sum for arr[0..i]
    def dp(i)
      return 0 if i < 0

      cached = @memo[i]
      return cached unless cached.nil?

      best = 0
      max_val = 0

      (1..@k).each do |len|
        j = i - len + 1
        break if j < 0

        max_val = [max_val, @arr[j]].max
        best = [best, dp(j - 1) + max_val * len].max
      end

      @memo[i] = best
    end

    def validate_inputs!(arr, k)
      raise ArgumentError, "arr must be an Array" unless arr.is_a?(Array)
      raise ArgumentError, "k must be a positive integer" unless k.is_a?(Integer) && k > 0
      unless arr.all? { |x| x.is_a?(Integer) }
        raise ArgumentError, "arr elements must be integers"
      end
    end
  end
end