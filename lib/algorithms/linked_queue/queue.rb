module Algorithms
  module LinkedQueue
    Node = Struct.new(:val, :next)
    class Queue
      def initialize
        @head = @tail = nil
      end

      def enqueue(val)
        node = Node.new(val)
        if empty?
          @head = @tail = node
        else
          @tail.next = node
          @tail = node
        end
      end

      def dequeue
        return nil if empty?

        val = @head.val
        @head = @head.next
        @tail = nil if empty?
        val
      end

      def empty?
        @head.nil?
      end
    end
  end
end