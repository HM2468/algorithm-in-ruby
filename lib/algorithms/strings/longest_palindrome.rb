# lib/algorithms/strings/longest_palindronme.rb
=begin
  Longest palindromic Substring
  给定一个字符串 s，找到 s 中最长的回文子串。
  示例：
    - "babad" => "bab" 或 "aba"
    - "cbbd"  => "bb"
  思路：
  使用中心扩展法（Expand Around Center）：
  1. 回文中心可以是一个字符（奇数长度回文）或两个字符之间（偶数长度回文）。
  2. 从每个回文中心开始，向两边扩展，直到不能扩展为止。
  3. 分奇偶两种情况扩展：
     - 奇数长度回文：以 s[i] 为中心，左右同时扩展
     - 偶数长度回文：以 s[i] 和 s[i+1] 为中心，左右同时扩展
  4. 记录下最长的回文子串。
=end

module Algorithms
  module Strings

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
        # 跳出循环时，left 和 right 已经超出回文范围
        # 回文的起点是 left + 1，长度是 right - left - 1
        [left + 1, right - left - 1]
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