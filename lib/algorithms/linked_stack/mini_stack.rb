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