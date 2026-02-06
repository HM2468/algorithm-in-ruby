# frozen_string_literal: true

=begin
516. Longest Palindromic Subsequence (LPS)

Given a string s, return the length of the longest palindromic subsequence.

A subsequence is derived by deleting some (or none) characters
without changing the relative order of the remaining characters.

Conventions (interval DP with extra empty interval semantics):
  - n = s.length
  - dp is sized (n+1) x (n+1)
  - dp[i][j] represents the LPS length of substring:
      s[i...j]   (i inclusive, j exclusive)
  - dp[i][i] = 0        (empty interval)
  - dp[i][i+1] = 1      (single character)

Transition:
  if s[i] == s[j-1]:
    dp[i][j] = dp[i+1][j-1] + 2
  else:
    dp[i][j] = max(dp[i+1][j], dp[i][j-1])

@param s [String]
@return [Integer]
=end

module DP
  class LongestPalindromicSubsequence
    # Memoization (top-down, interval DP)
    #
    # dp(i, j): LPS length of s[i...j]
    #
    # Base:
    #   dp(i, i)   = 0
    #   dp(i, i+1) = 1
    #
    # Time:  O(n^2)
    # Space: O(n^2) memo + recursion stack
    def memoization(s)
      validate_string!(s)

      @s = s
      @n = s.length
      @memo = Array.new(@n + 1) { Array.new(@n + 1, nil) }

      dp(0, @n)
    end

    # Tabulation (bottom-up) - full 2D table
    #
    # Time:  O(n^2)
    # Space: O(n^2)
    def tabulation(s)
      validate_string!(s)

      n = s.length
      dp = Array.new(n + 1) { Array.new(n + 1, 0) }

      # dp[i][i] = 0 (empty interval)
      # dp[i][i+1] = 1 (single char)
      (0...n).each do |i|
        dp[i][i + 1] = 1
      end

      # Fill by increasing interval length
      (2..n).each do |len|
        (0..n - len).each do |i|
          j = i + len
          if s[i] == s[j - 1]
            dp[i][j] = dp[i + 1][j - 1] + 2
          else
            dp[i][j] = [dp[i + 1][j], dp[i][j - 1]].max
          end
        end
      end

      dp[0][n]
    end

    # Tabulation (bottom-up) - 1D optimized
    #
    # dp[j] represents dp[i][j] for current i
    #
    # We iterate i from n-1 down to 0
    #
    # Time:  O(n^2)
    # Space: O(n)
    def tabulation_1d(s)
      validate_string!(s)

      n = s.length
      return 0 if n == 0

      dp = Array.new(n + 1, 0)

      (n - 1).downto(0) do |i|
        prev_diag = 0
        dp[i + 1] = 1
        (i + 2..n).each do |j|
          temp = dp[j]
          if s[i] == s[j - 1]
            dp[j] = prev_diag + 2
          else
            dp[j] = [dp[j], dp[j - 1]].max
          end
          prev_diag = temp
        end
      end

      dp[n]
    end

    private

    # dp(i, j): LPS length of s[i...j]
    def dp(i, j)
      return 0 if i >= j
      return 1 if j == i + 1

      cached = @memo[i][j]
      return cached unless cached.nil?

      if @s[i] == @s[j - 1]
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