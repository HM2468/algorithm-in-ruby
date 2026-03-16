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
  - window is valid if no duplicated characters inside
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
    # left: left boundary of window (inclusive)
    # right: right boundary of window (inclusive)
    #
    # last_pos[ch]: last index where character ch appeared
    #
    # Invariant:
    #   s[left..right] contains no duplicate characters
    #
    # Time:  O(n)
    # Space: O(min(n, charset_size))
    def length_of_longest_substring(s)
      raise ArgumentError, "s must be a String" unless s.is_a?(String)
      return 0 if s.empty?

      n = s.length
      last_pos = {}
      left = 0
      best = 0

      (0...n).each do |right|
        current_char = s[right]
        # If ch already exists in current window, move left pointer
        if last_pos.key?(current_char) && last_pos[current_char] >= left
          left = last_pos[current_char] + 1
        end
        last_pos[current_char] = right
        best = [best, right - left + 1].max
      end
      best
    end
  end
end