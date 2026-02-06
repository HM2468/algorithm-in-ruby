# frozen_string_literal: true

=begin
3. Longest Substring Without Repeating Characters

Given a string s, find the length of the longest substring
without repeating characters.

A substring is a contiguous sequence of characters.

Conventions (sliding window / two pointers):
  - Use a window [l..r] (inclusive indices)
  - The window always maintains the invariant:
      all characters inside s[l..r] are unique

State / invariant:
  - window is valid iff no duplicated characters inside
  - last_pos[ch] stores the most recent index of character ch

Algorithm idea:
  - Expand right pointer r step by step
  - If s[r] has appeared inside the current window:
      move left pointer l to (last_pos[s[r]] + 1)
  - Update last_pos[s[r]] = r
  - Track the maximum window length

Key insight:
  - Each index moves forward at most once
  - Total time is linear

Time complexity:
  - O(n)

Space complexity:
  - O(min(n, charset_size))

@param s [String]
@return [Integer]
=end

module SlidingWindow
  class LongestSubstring
    # Sliding Window / Two Pointers
    #
    # l: left boundary of window (inclusive)
    # r: right boundary of window (inclusive)
    #
    # last_pos[ch]: last index where character ch appeared
    #
    # Invariant:
    #   s[l..r] contains no duplicate characters
    #
    # Time:  O(n)
    # Space: O(min(n, charset))
    def length_of_longest_substring(s)
      validate_string!(s)

      n = s.length
      return 0 if n == 0

      last_pos = {}
      l = 0
      best = 0

      (0...n).each do |r|
        ch = s[r]

        # If ch already exists in current window, move left pointer
        if last_pos.key?(ch) && last_pos[ch] >= l
          l = last_pos[ch] + 1
        end

        last_pos[ch] = r
        best = [best, r - l + 1].max
      end

      best
    end

    private

    def validate_string!(s)
      raise ArgumentError, "s must be a String" unless s.is_a?(String)
    end
  end
end