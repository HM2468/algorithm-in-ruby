# frozen_string_literal: true

=begin
1143. Longest Common Subsequence (LCS)

Given two strings text1 and text2, return the length of their longest common subsequence.

Conventions (align with the classic "extra empty row/col" DP table):
  - m = text1.length
  - n = text2.length
  - dp is sized (m+1) x (n+1)
  - dp[0][j] = 0 for all j (empty prefix of text1)
  - dp[i][0] = 0 for all i (empty prefix of text2)

State meaning:
  dp[i][j] = LCS length of:
    text1[0...(i)]  (first i chars)
    text2[0...(j)]  (first j chars)

Transition:
  if text1[i-1] == text2[j-1]
    dp[i][j] = dp[i-1][j-1] + 1
  else
    dp[i][j] = max(dp[i-1][j], dp[i][j-1])

We provide multiple implementations:
  1) tabulation        : full 2D dp (m+1) x (n+1)
  2) tabulation_1d     : 1D optimized with the same empty row/col semantics (O(min(m,n)))
  3) memoization       : top-down recursion over (i,j) where i/j are lengths (0..m, 0..n),
                         with base dp(0,*)=0 and dp(*,0)=0 (same semantics)

@param text1 [String]
@param text2 [String]
@return [Integer]
=end

module DP
  class LongestCommonSubsequence
    # Memoization (top-down), but with the same "length-based" semantics as the 2D table:
    #   dp(i, j) = LCS length of text1[0...i] and text2[0...j]
    #
    # Base:
    #   dp(0, j) = 0
    #   dp(i, 0) = 0
    #
    # Time:  O(m*n)
    # Space: O(m*n) memo + recursion stack O(m+n)
    def memoization(text1, text2)
      validate_texts!(text1, text2)

      @s1 = text1
      @s2 = text2
      @m  = @s1.length
      @n  = @s2.length

      @memo = Array.new(@m + 1) { Array.new(@n + 1, nil) } # memo for dp(i,j)
      dp(@m, @n)
    end

    # Tabulation (bottom-up) - full 2D table with reserved empty row/col
    #
    # Time:  O(m*n)
    # Space: O(m*n)
    def tabulation(text1, text2)
      validate_texts!(text1, text2)

      m = text1.length
      n = text2.length

      dp = Array.new(m + 1) { Array.new(n + 1, 0) }

      # Explicitly initialize the reserved empty row/col (kept for clarity)
      (0..n).each { |j| dp[0][j] = 0 }
      (0..m).each { |i| dp[i][0] = 0 }

      (1..m).each do |i|
        (1..n).each do |j|
          if text1[i - 1] == text2[j - 1]
            dp[i][j] = dp[i - 1][j - 1] + 1
          else
            dp[i][j] = [dp[i - 1][j], dp[i][j - 1]].max
          end
        end
      end

      dp[m][n]
    end

    # Tabulation (bottom-up) - 1D optimized, still using the "extra empty row/col" semantics
    #
    # dp[j] corresponds to dp[current_i][j] in the 2D table.
    # Base row dp[0..n] starts as 0, representing dp[0][j] = 0.
    #
    # Transition (for i in 1..m, j in 1..n):
    #   prev_diag holds dp[i-1][j-1]
    #   temp_up   holds old dp[j] == dp[i-1][j]
    #
    # Space: O(min(m,n)) by choosing the shorter string as "columns".
    def tabulation_1d(text1, text2)
      validate_texts!(text1, text2)

      m = text1.length
      n = text2.length
      return 0 if m == 0 || n == 0

      # Choose shorter as columns to minimize space
      rows_str, cols_str =
        if m >= n
          [text1, text2] # rows = text1, cols = text2
        else
          [text2, text1] # swap
        end

      rows = rows_str.length
      cols = cols_str.length

      # dp[0]..dp[cols] (note: cols+1 length) => dp[0][j] = 0 initially
      dp = Array.new(cols + 1, 0)

      (1..rows).each do |i|
        prev_diag = 0 # dp[i-1][0] is always 0
        (1..cols).each do |j|
          temp_up = dp[j] # old dp[i-1][j]
          if rows_str[i - 1] == cols_str[j - 1]
            dp[j] = prev_diag + 1
          else
            dp[j] = [dp[j], dp[j - 1]].max
          end
          prev_diag = temp_up
        end
      end

      dp[cols]
    end

    private

    # dp(i, j): LCS length of prefixes @s1[0...i] and @s2[0...j]
    def dp(i, j)
      return 0 if i == 0 || j == 0

      cached = @memo[i][j]
      return cached unless cached.nil?

      if @s1[i - 1] == @s2[j - 1]
        @memo[i][j] = dp(i - 1, j - 1) + 1
      else
        @memo[i][j] = [dp(i - 1, j), dp(i, j - 1)].max
      end
    end

    def validate_texts!(text1, text2)
      unless text1.is_a?(String) && text2.is_a?(String)
        raise ArgumentError, "text1 and text2 must be Strings"
      end
    end
  end
end