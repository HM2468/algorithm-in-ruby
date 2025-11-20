# lib/algorithms/strings/longest_palindronme.rb

module Algorithms
  module Strings
    # Longest palindromic Substring
    #
    # 给定一个字符串 s，找到 s 中最长的回文子串。
    #
    # 示例：
    #  - "babad" => "bab" 或 "aba"
    #  - "cbbd"  => "bb"
    #
    # @param s [String]
    # @return [String]
    def longest_palindrome(s)
      return "" if s.nil? || s.empty?
      max_len = 1
      start_idx = 0

      expand_around_center = lambda do |left, right|
        while left >= 0 && right < s.length && s[left] == s[right]
          left -= 1
          right += 1
        end
        [left + 1, right - left - 1]  # 返回回文子串的起始和长度
      end

      (0...s.length).each do |i|
        odd_idx, odd_len = expand_around_center.call(i, i)
        if odd_len > max_len
          max_len = odd_len
          start_idx = odd_idx
        end

        even_idx, even_len = expand_around_center.call(i, i + 1)
        if even_len > max_len
          max_len = even_len
          start_idx = even_idx
        end
      end
      s[start_idx, max_len]
    end
  end
end