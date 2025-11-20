# lib/algorithms/strings/longest_substring_without_repeating_characters.rb

module Algorithms
  module Strings
    # Longest Substring Without Repeating Characters
    #
    # 给定一个字符串 s，返回其中「不含重复字符的最长子串」的长度。
    #
    # 示例：
    #  - "abcabcbb" => 3 ("abc")
    #  - "bbbbb"    => 1 ("b")
    #  - "pwwkew"   => 3 ("wke")
    #
    # @param s [String]
    # @return [Integer]
    def self.length_of_longest_substring(s)
      last_index = {}  # 记录字符上一次出现的下标：char => index
      left = 0         # 当前窗口的左边界
      max_len = 0      # 记录历史最长无重复子串长度

      s.chars.each_with_index do |ch, right|
        # 如果 ch 出现过，并且上一次出现位置在当前窗口内
        if last_index.key?(ch) && last_index[ch] >= left
          # 把 left 移到上一次出现的下一位，排除掉重复字符
          left = last_index[ch] + 1
        end

        # 更新当前字符的最新出现位置
        last_index[ch] = right

        # 当前窗口长度 = right - left + 1
        window_len = right - left + 1
        max_len = [max_len, window_len].max
      end

      max_len
    end
  end
end