# frozen_string_literal: true

=begin
516. Longest Palindromic Subsequence (LPS)

Given a string s, return the length of the longest palindromic subsequence.

A subsequence is derived by deleting some (or none) characters
without changing the relative order of the remaining characters.

Conventions (interval DP, inclusive indices):
  - n = s.length
  - dp is sized n x n
  - dp[i][j] represents the LPS length of substring:
      s[i..j]   (i and j are both inclusive)
  - i <= j

State meaning:
  dp[i][j] = length of the longest palindromic subsequence in s[i..j]

Base cases:
  - dp[i][i] = 1          (single character)
  - i > j    => 0         (empty interval, used implicitly)

Transition:
  If s[i] == s[j]:
    dp[i][j] = dp[i+1][j-1] + 2
  Else:
    dp[i][j] = max(dp[i+1][j], dp[i][j-1])

Final answer:
  dp[0][n-1]

@param s [String]
@return [Integer]
=end

module DP
  class LongestPalindromicSubsequence
    # Memoization (top-down, interval DP, inclusive indices)
    #
    # dp(i, j): LPS length of s[i..j]
    #
    # Base:
    #   i > j  => 0
    #   i == j => 1
    #
    # Time:  O(n^2)
    # Space: O(n^2) memo + recursion stack
    def memoization(s)
      validate_string!(s)

      @s = s
      n = s.length
      return 0 if n == 0

      @memo = Array.new(n) { Array.new(n, nil) }
      dp(0, n - 1)
    end

    # Tabulation (bottom-up) - full 2D table
    # Fill order:
    #       j →
    #       0   1   2   3   4
    #
    # i=0   1   2   3   4   5
    # i=1       1   2   3   4
    # i=2           1   2   3
    # i=3               1   2
    # i=4                   1
    #
    # Time:  O(n^2)
    # Space: O(n^2)
    def tabulation(s)
      validate_string!(s)
      n = s.length
      return 0 if n == 0

      dp = Array.new(n) { Array.new(n, 0) }
      # Base: single character
      (0...n).each do |i|
        dp[i][i] = 1
      end

      # Interval length from 2 to n
      (2..n).each do |len|
        (0..n - len).each do |i|
          j = i + len - 1
          if s[i] == s[j]
            dp[i][j] = dp[i + 1][j - 1] + 2
          else
            dp[i][j] = [dp[i + 1][j], dp[i][j - 1]].max
          end
        end
      end

      dp[0][n - 1]
    end

    # Tabulation (bottom-up) - 1D optimized
    #
    # dp[j] represents dp[i][j] for current i
    #
    # Iteration order:
    #   i from n-1 downto 0
    #   j from i+1 upto n-1
    #
    # prev_diag holds old dp[i+1][j-1]
    #
    # Time:  O(n^2)
    # Space: O(n)
    def tabulation_1d(s)
      validate_string!(s)

      n = s.length
      return 0 if n == 0

      dp = Array.new(n, 0)

      (n - 1).downto(0) do |i|
        dp[i] = 1            # dp[i][i] = 1
        prev_diag = 0        # represents dp[i+1][j-1]

        (i + 1...n).each do |j|
          temp = dp[j]
          if s[i] == s[j]
            dp[j] = prev_diag + 2
          else
            dp[j] = [dp[j], dp[j - 1]].max
          end
          prev_diag = temp
        end
      end

      dp[n - 1]
    end

    private

    # dp(i, j): LPS length of s[i..j]
    def dp(i, j)
      return 0 if i > j
      return 1 if i == j

      cached = @memo[i][j]
      return cached unless cached.nil?

      if @s[i] == @s[j]
        @memo[i][j] = dp(i + 1, j - 1) + 2
      else
        @memo[i][j] = [dp(i + 1, j), dp(i, j - 1)].max
      end
    end

    def validate_string!(s)
      raise ArgumentError, "s must be a String" unless s.is_a?(String)
    end
  end
end