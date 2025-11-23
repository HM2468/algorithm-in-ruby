module Algorithms
  module LinkedLists

    # 141. Linked List Cycle
    # 返回 true/false
    def has_cycle?(head)
      slow = head
      fast = head
      while fast && fast.next
        slow = slow.next
        fast = fast.next.next
        return true if slow == fast
      end
      false
    end
  end
end