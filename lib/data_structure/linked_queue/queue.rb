module DataStructure
  module LinkedQueue
    Node = Struct.new(:val, :next)

    class Queue
      def initialize
        @head = @tail = nil
      end

      # Enqueue an element at the end of the queue
      def enqueue(val)
        node = Node.new(val)
        if empty?
          @head = @tail = node
        else
          @tail.next = node
          @tail = node
        end
      end

      # Dequeue an element from the front of the queue
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