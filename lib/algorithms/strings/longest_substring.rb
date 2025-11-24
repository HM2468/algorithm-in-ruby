# lib/algorithms/strings/longest_substring.rb
=begin
    Longest Substring Without Repeating Characters
    给定一个字符串 s，返回其中「不含重复字符的最长子串」的长度。
    示例：
     - "abcabcbb" => 3 ("abc")
     - "bbbbb"    => 1 ("b")
     - "pwwkew"   => 3 ("wke")
    思路：
    使用滑动窗口技巧(sliding window)：
    1. 用一个哈希表 last_index 记录每个字符上一次出现的下标。
    2. 使用两个指针 left 和 right，表示当前窗口的左右边界，初始都指向字符串开头。
    3. 遍历字符串：
       - 对于每个字符 s[right]，检查它是否在 last_index 中出现过，且上次出现的位置在当前窗口内（即 last_index[s[right]] >= left）。
       - 如果是，则将 left 移动到 last_index[s[right]] + 1，排除掉重复字符。
       - 更新 last_index[s[right]] 为当前下标 right。
       - 计算当前窗口长度 right - left + 1，更新最大长度 max_len。
    4. 遍历结束后，max_len 即为所求结果。
=end

module Algorithms
  module Strings
    # @param s [String]
    # @return [Integer]
    def length_of_longest_substring(s)
      last_index = {}  # 记录字符上一次出现的下标：char => index
      left = 0         # 当前窗口的左边界
      max_len = 0      # 记录历史最长无重复子串长度

      s.chars.each_with_index do |ch, right|
        # 如果 ch 出现过，并且上一次出现位置在当前窗口内
        if last_index[ch] && last_index[ch] >= left
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