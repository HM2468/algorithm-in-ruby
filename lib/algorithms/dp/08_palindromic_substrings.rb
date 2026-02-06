# frozen_string_literal: true

=begin
647. Palindromic Substrings
Given a string s, return the number of palindromic substrings in it.
A substring is a contiguous sequence of characters within the string.

Conventions (interval DP, inclusive indices):
  - n = s.length
  - dp is sized n x n
  - dp[i][j] indicates whether s[i..j] is a palindrome
  - i <= j

State meaning:
  dp[i][j] = true  if substring s[i..j] is palindromic
           = false otherwise

Base cases:
  - dp[i][i] = true              (single character)
  - dp[i][i+1] = (s[i] == s[i+1])

Transition:
  For j - i >= 2:
    dp[i][j] = (s[i] == s[j]) && dp[i+1][j-1]

Counting:
  Count all (i, j) where dp[i][j] == true

Final answer:
  Total count of palindromic substrings

@param s [String]
@return [Integer]
=end

module DP
  class PalindromicSubstrings
    # Memoization (top-down, interval DP)
    #
    # pal?(i, j): whether s[i..j] is a palindrome
    #
    # Time:  O(n^2)
    # Space: O(n^2)
    def memoization(s)
      validate_string!(s)
      n = s.length
      return 0 if n == 0

      @s = s
      @memo = Array.new(n) { Array.new(n, nil) }

      count = 0
      (0...n).each do |i|
        (i...n).each do |j|
          count += 1 if pal?(i, j)
        end
      end

      count
    end

    # Tabulation (bottom-up) - interval DP
    #
    # Fill order:
    #   - increasing interval length
    #
    # Time:  O(n^2)
    # Space: O(n^2)
    def tabulation(s)
      validate_string!(s)
      n = s.length
      return 0 if n == 0

      dp = Array.new(n) { Array.new(n, false) }
      count = 0

      # len = 1 (single characters)
      (0...n).each do |i|
        dp[i][i] = true
        count += 1
      end

      # len >= 2
      (2..n).each do |len|
        (0..n - len).each do |i|
          j = i + len - 1
          if s[i] == s[j]
            dp[i][j] = (len == 2) || dp[i + 1][j - 1]
          else
            dp[i][j] = false
          end
          count += 1 if dp[i][j]
        end
      end

      count
    end

    # Center Expansion (optimal solution)
    #
    # For each center:
    #   - odd-length palindromes
    #   - even-length palindromes
    #
    # Time:  O(n^2)
    # Space: O(1)
    def center_expand(s)
      validate_string!(s)
      n = s.length
      return 0 if n == 0

      count = 0

      (0...n).each do |center|
        count += expand(s, center, center)     # odd
        count += expand(s, center, center + 1) # even
      end

      count
    end

    private

    def pal?(i, j)
      return true if i >= j

      cached = @memo[i][j]
      return cached unless cached.nil?

      @memo[i][j] =
        (@s[i] == @s[j]) && pal?(i + 1, j - 1)
    end

    def expand(s, l, r)
      count = 0
      while l >= 0 && r < s.length && s[l] == s[r]
        count += 1
        l -= 1
        r += 1
      end
      count
    end

    def validate_string!(s)
      raise ArgumentError, "s must be a String" unless s.is_a?(String)
    end
  end
end