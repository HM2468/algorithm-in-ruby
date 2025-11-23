=begin
  一、最小栈（Min Stack）
  1. 题目要干啥？
  实现一个栈，支持四个操作：
  - push(x)：压栈
  - pop()：出栈
  - top()：返回栈顶元素
  - get_min()：返回栈中最小元素，要求 O(1) 时间复杂度
  2. 核心思路：用两个栈
  - 一个正常栈：存所有元素，叫 @stack
  - 一个“最小栈”：存当前路径上的最小值，叫 @min_stack
  规则：
  - push(x)：
      - 正常：@stack.push(x)
      - 最小栈：
          - 如果 @min_stack 为空，或者 x <= 当前最小值，就把 x 也压到 @min_stack
  - pop：
      - 正常栈弹出 val = @stack.pop
      - 如果 val == @min_stack.last，说明当前最小值被弹掉了，@min_stack 也要 pop 一下
  - top：@stack.last
  - get_min：@min_stack.last
  时间复杂度：所有操作都是 O(1)。
=end


module Algorithms
  module LinkedStack
    class MinStack
      def initialize
        @stack     = Stack.new  # 正常栈：存所有元素
        @min_stack = Stack.new  # 辅助栈：存当前“最小值轨迹”
      end

      # 压栈
      def push(val)
        @stack.push(val)

        # 如果当前没有最小值，或者新值更小 / 相等，就同步压入 min_stack
        if @min_stack.empty? || val <= @min_stack.peek
          @min_stack.push(val)
        end
      end

      # 出栈（返回弹出的值；空栈时返回 nil）
      def pop
        return nil if @stack.empty?

        val = @stack.pop
        # 如果弹出的值正好是当前最小值，也要从 min_stack 里弹出一份
        @min_stack.pop if !@min_stack.empty? && val == @min_stack.peek
        val
      end

      # 栈顶元素
      def top
        @stack.peek
      end

      # 当前最小值
      def get_min
        @min_stack.peek
      end

      # 是否为空（可选）
      def empty?
        @stack.empty?
      end
    end
  end
end