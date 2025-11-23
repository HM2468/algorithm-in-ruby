# file: lib/algorithms/linked-lists/basic.rb

module Algorithms
  module LinkedLists
    Node = Struct.new(:val, :next)

    def build_linked_list(arr)
      return nil if arr.empty?

      head = Node.new(arr[0])
      current = head
      arr[1..-1].each do |value|
        current.next = Node.new(value)
        current = current.next
      end
      head
    end

    def print_linked_list(head)
      current = head
      while current
        print "#{current.val} -> "
        current = current.next
      end
      puts "nil"
    end

    # 小工具：把链表转换成数组，方便断言
    def list_to_array(head)
      result  = []
      current = head
      while current
        result << current.val
        current = current.next
      end
      result
    end

    # 小工具：收集链表中每个节点的 object_id，用来判断有没有“新建节点”
    def node_object_ids(head)
      ids     = []
      current = head
      while current
        ids << current.object_id
        current = current.next
      end
      ids
    end

    # 构造带环链表：tail.next 指向下标为 pos 的节点
    # pos = -1 / nil 表示无环
    def build_cyclic_list(values, pos)
      head = build_linked_list(values)
      return head if head.nil? || pos.nil? || pos < 0

      index     = 0
      current   = head
      entry     = nil
      tail      = nil

      while current
        entry = current if index == pos
        tail  = current
        current = current.next
        index += 1
      end

      raise ArgumentError, "pos out of range" unless entry

      tail.next = entry
      head
    end

    def node_at(head, index)
      current = head
      i = 0
      while current && i < index
        current = current.next
        i += 1
      end
      current
    end
  end
end