# frozen_string_literal: true

=begin
Brute Force: Generate All Substrings

Given a string s, return all possible substrings of s.

A substring is a contiguous sequence of characters.
For a string of length n, every substring can be uniquely identified
by a pair of indices (start, ending) such that:

  0 <= start <= ending < n

Algorithm idea (brute force):
  - Enumerate every possible start index
  - For each start index, enumerate every possible ending index
    from start to the end of the string
  - Extract s[start..ending] and append it to the result

Example:
  s = "abc"

  start = 0
    ending = 0  -> "a"
    ending = 1  -> "ab"
    ending = 2  -> "abc"

  start = 1
    ending = 1  -> "b"
    ending = 2  -> "bc"

  start = 2
    ending = 2  -> "c"

  result = ["a", "ab", "abc", "b", "bc", "c"]

Number of substrings:
  - Total count = n * (n + 1) / 2

Time complexity:
  - If only enumerating (start, ending) pairs: O(n^2)
  - Since this implementation actually creates each substring
    via s[start..ending], substring extraction costs O(length)
  - Total time complexity: O(n^3)

Space complexity:
  - If not storing results, extra space would be O(1) (excluding output)
  - This implementation stores all substrings
  - Number of substrings is O(n^2), but total characters stored
    across all substrings is O(n^3)
  - Total output space: O(n^3)

@param s [String]
@return [Array<String>]
=end

module SlidingWindow
  class BrutalForceSubstring
    # Brute force / double loop
    #
    # start:  left boundary of substring (inclusive)
    # ending: right boundary of substring (inclusive)
    #
    # For each pair (start, ending), extract s[start..ending]
    # and append it to result.
    #
    # Time:
    #   - O(n^3) including substring copying
    #
    # Space:
    #   - O(n^3) if storing all substrings
    def all_substrings(s)
      raise ArgumentError, "s must be a String" unless s.is_a?(String)

      result = []

      (0...s.length).each do |start|
        (start...s.length).each do |ending|
          result << s[start..ending]
        end
      end

      result
    end
  end
end