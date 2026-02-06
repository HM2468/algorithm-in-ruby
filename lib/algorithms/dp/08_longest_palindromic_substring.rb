# frozen_string_literal: true

=begin
5. Longest Palindromic Substring

Given a string s, return the longest palindromic substring in s.

A substring is a contiguous sequence of characters within the string.

Conventions (interval DP, inclusive indices):
  - n = s.length
  - dp is sized n x n
  - dp[i][j] indicates whether substring s[i..j] is a palindrome
  - i <= j

State meaning:
  dp[i][j] = true  if s[i..j] is palindromic
           = false otherwise

Base cases:
  - dp[i][i] = true                           (single char)
  - dp[i][i+1] = (s[i] == s[i+1])             (two chars)

Transition:
  For j - i >= 2:
    dp[i][j] = (s[i] == s[j]) && dp[i+1][j-1]

Final answer:
  Return the substring s[l..r] where (r-l+1) is maximum among palindromes.

We provide multiple implementations:
  1) memoization  : top-down pal?(i,j) with caching (O(n^2))
  2) tabulation   : bottom-up dp table (O(n^2))
  3) center_expand: expand around each center (O(n^2) time, O(1) space)

@param s [String]
@return [String]
=end

module DP
  class LongestPalindromicSubstring
    # Memoization (top-down, interval DP, inclusive indices)
    #
    # pal?(i, j): whether s[i..j] is palindrome
    #
    # Time:  O(n^2)
    # Space: O(n^2) memo + recursion stack
    def memoization(s)
      validate_string!(s)
      n = s.length
      return "" if n == 0
      return s if n == 1

      @s = s
      @memo = Array.new(n) { Array.new(n, nil) }

      best_l = 0
      best_r = 0

      # enumerate all intervals (i..j), ask pal?(i,j)
      (0...n).each do |i|
        (i...n).each do |j|
          next unless pal?(i, j)

          if (j - i) > (best_r - best_l)
            best_l = i
            best_r = j
          end
        end
      end

      s[best_l..best_r]
    end

    # Tabulation (bottom-up) - full 2D table
    #
    # dp[i][j] indicates palindrome for s[i..j]
    #
    # Fill order:
    #   - length 1 base
    #   - length 2 base
    #   - length 3..n increasing
    #
    # Time:  O(n^2)
    # Space: O(n^2)
    def tabulation(s)
      validate_string!(s)
      n = s.length
      return "" if n == 0
      return s if n == 1

      dp = Array.new(n) { Array.new(n, false) }

      best_l = 0
      best_r = 0

      # len = 1
      (0...n).each do |i|
        dp[i][i] = true
      end

      # len = 2
      (0...n - 1).each do |i|
        j = i + 1
        if s[i] == s[j]
          dp[i][j] = true
          best_l = i
          best_r = j
        end
      end

      # len >= 3
      (3..n).each do |len|
        (0..n - len).each do |i|
          j = i + len - 1
          if s[i] == s[j] && dp[i + 1][j - 1]
            dp[i][j] = true
            if (j - i) > (best_r - best_l)
              best_l = i
              best_r = j
            end
          end
        end
      end

      s[best_l..best_r]
    end

    # Center expansion (optimal practice)
    #
    # For each center:
    #   - odd-length center at (c,c)
    #   - even-length center at (c,c+1)
    #
    # Keep best (l,r).
    #
    # Time:  O(n^2)
    # Space: O(1)
    def center_expand(s)
      validate_string!(s)
      n = s.length
      return "" if n == 0
      return s if n == 1

      best_l = 0
      best_r = 0

      (0...n).each do |c|
        l1, r1 = expand(s, c, c)
        if (r1 - l1) > (best_r - best_l)
          best_l = l1
          best_r = r1
        end

        l2, r2 = expand(s, c, c + 1)
        if (r2 - l2) > (best_r - best_l)
          best_l = l2
          best_r = r2
        end
      end

      s[best_l..best_r]
    end

    private

    # pal?(i, j): whether @s[i..j] is palindrome
    def pal?(i, j)
      return true if i >= j

      cached = @memo[i][j]
      return cached unless cached.nil?

      @memo[i][j] = (@s[i] == @s[j]) && pal?(i + 1, j - 1)
    end

    def expand(s, l, r)
      while l >= 0 && r < s.length && s[l] == s[r]
        l -= 1
        r += 1
      end
      [l + 1, r - 1] # stepped one too far
    end

    def validate_string!(s)
      raise ArgumentError, "s must be a String" unless s.is_a?(String)
    end
  end
end