# lib/algorithms/strings/longest_substring.rb
=begin
    Longest Substring Without Repeating Characters
    给定一个字符串 s，返回其中「不含重复字符的最长子串」的长度。
    示例：
     • "abcabcbb" => 3 ("abc")
     • "bbbbb"    => 1 ("b")
     • "pwwkew"   => 3 ("wke")

    面试在考什么？

    这题是 LeetCode / 面试里非常高频的一道题，主要考：
    • 对「子串 / 子序列」的概念是否清晰
    • 子串必须连续，这决定了我们很适合用「滑动窗口」。
    • 滑动窗口（two pointers）思维
    • 能不能想到用左指针 + 右指针维护一个 “当前窗口”，窗口里保证没有重复字符。

    Hash / Map 的运用
    • 用 Hash 记录字符上一次出现的位置，辅助快速移动左指针，保证 O(n) 时间复杂度。
    时间复杂度优化意识
    • 暴力所有子串是 O(n²) 或 O(n³)，但优秀解法是 O(n)。

    暴力方式：
    • 枚举所有子串 s[i…j]
    • 对每个子串检测是否有重复字符
    • 取最长的一个
    复杂度：
    • 子串数量 ~ O(n²)
    • 检查每个子串是否重复 O(n)
    • 总体最坏 O(n³) → 面试肯定不满意

    2. 标准解法：滑动窗口 + Hash（推荐）

    核心思想：

    • 用两个指针 left 和 right 表示当前「无重复子串」的窗口 [left, right]
    • 遍历字符串，用 right 从左往右扫：
    • 当前字符为 ch = s[right]
    • 用一个 Hash last_index[ch] 记录这个字符上一次出现的位置
    • 如果 ch 在当前窗口内已经出现过，就把 left 移动到「上一次出现位置的下一位」
    • 每一步更新窗口长度 right - left + 1，维护一个 max_len

    重点细节：
    • 为什么 left 只会向右移动、不会往回？
    • 因为我们要维护的是「当前尽量长的无重复窗口」，一旦遇到重复，我们只会把左边多挪走一些，不会再去考虑更小的左边界。
    • 判断「上一次出现是否在当前窗口内」：
    • 如果 last_index[ch] >= left，说明重复是在当前窗口里，要动 left
    • 如果 last_index[ch] < left，说明之前出现过，但已经不在当前窗口中，无需理会
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