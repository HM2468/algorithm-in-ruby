module Algorithms
  module LinkedLists


    # 19. Remove Nth Node From End of List
    # head: 头结点, n: 倒数第 n 个
    # 返回新的头结点
    def remove_nth_from_end(head, n)
      dummy = Node.new(nil, head)
      fast  = dummy
      slow  = dummy
      # 先让 fast 走 n 步，和 slow 之间间隔 n 个节点
      n.times do
        if fast.nil?
          raise ArgumentError, "The length of the linked list is less than n."
        end
        fast = fast.next
      end
      # fast 再往前走，直到它到达链表尾部
      # 此时 slow 恰好停在“要删除节点的前一个”
      while fast.next
        fast = fast.next
        slow = slow.next
      end
      # 删除 slow 后面的那个节点
      slow.next = slow.next&.next
      dummy.next
    end
  end
end