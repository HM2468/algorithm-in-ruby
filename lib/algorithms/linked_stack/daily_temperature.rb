=begin
  每日温度（Daily Temperatures）——单调栈典范

  Given an array of integers temperatures represents the daily temperatures,
  return an array answer such that answer[i] is the number of days you have
  to wait after the ith day to get a warmer temperature. If there is no future
  day for which this is possible, keep answer[i] == 0 instead.

  Example 1:
  Input: temperatures = [73,74,75,71,69,72,76,73]
  Output: [1,1,4,2,1,1,0,0]

  Example 2:
  Input: temperatures = [30,40,50,60]
  Output: [1,1,1,0]

  Example 3:
  Input: temperatures = [30,60,90]
  Output: [1,1,0]

  暴力思路（TLE 教学用途）
    • 对每个 i，往右扫 j = i+1…，找第一个 temperatures[j] > temperatures[i]
    • 复杂度 O(n²)，面试 / LeetCode 通常会超时。

  核心思想：单调栈（monotonic decreasing stack）
    •	栈里存的是“天的下标”（i），不是温度本身。
    •	栈从底到顶，温度是单调递减的，只要新入栈的数比top大，就把top弹出并结算答案。
    •	结算答案过程：res[prev_index] = i - prev_index。解释：prev_index 天等了多少天才遇到更暖的一天？
    •	新入栈的下标 i 还没找到更暖的一天，先入栈，等后续天数来“结算”。
    •	这样每个下标最多进栈出栈各一次，复杂度 O(n)。
=end
module Algorithms
  module LinkedStack
    # @param {Integer[]} temperatures
    # @return {Integer[]}
    def daily_temperatures(temperatures)
      n = temperatures.length
      res = Array.new(n, 0)    # 默认全部是 0
      stack = Stack.new        # 栈里存“下标”
      temperatures.each_with_index do |temp, i|
        # 当前温度比栈顶那天更高，就说明栈顶那天等到了更暖的一天
        while !stack.empty? && temp > temperatures[stack.peek]
          prev_index = stack.pop                   # 栈顶那天的下标
          res[prev_index] = i - prev_index         # 两天相差的天数
        end
        # 当前这天还没找到比它更暖的未来，先压栈，等之后的天来“结算”
        stack.push(i)
      end
      res
    end
  end
end
