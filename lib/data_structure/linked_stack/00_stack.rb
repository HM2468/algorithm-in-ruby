module DataStructure
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
        val = @top&.val
        @top = @top&.next
        val
      end

      def empty?
        @top.nil?
      end

      def peek
        @top&.val
      end
    end
  end
end