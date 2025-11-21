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
  end
end