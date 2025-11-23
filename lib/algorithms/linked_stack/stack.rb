module Algorithms
  module LinkedStack
    Node = Struct.new(:val, :next)

    class Stack
      def initialize
        @top = nil
      end

      def push(val)
        node = Node.new(val, @top)
        @top = node
      end

      def pop
        return nil if @top.nil?

        val = @top.val
        @top = @top.next
        val
      end

      def empty?
        @top.nil?
      end
    end
  end
end