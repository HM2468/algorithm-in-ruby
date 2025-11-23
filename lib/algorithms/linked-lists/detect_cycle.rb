module Algorithms
  module LinkedLists
    # 142. Linked List Cycle II
    # 有环则返回环的入口节点，没有则返回 nil
    def detect_cycle(head)
      slow = head
      fast = head
      # 第一阶段：判断是否有环，并找到相遇点
      while fast && fast.next
        slow = slow.next
        fast = fast.next.next
        break if slow == fast
      end
      # 无环
      return nil unless fast && fast.next
      # 第二阶段：从 head 和 meet 同步走，第一次相遇即为入口
      slow = head
      while slow != fast
        slow = slow.next
        fast = fast.next
      end
      slow
    end
  end
end