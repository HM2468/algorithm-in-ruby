module Algorithms
  module LinkedLists
    # 21. Merge Two Sorted Lists
    # l1, l2 都是升序链表，返回升序合并后的头结点
    def merge_two_sorted_lists(l1, l2)
      dummy = Node.new(nil, nil)
      tail = dummy
      l1_current = l1
      l2_current = l2
      while l1_current && l2_current
        if l1_current.val <= l2_current.val
          tail.next = l1_current
          l1_current = l1_current.next
        else
          tail.next = l2_current
          l2_current = l2_current.next
        end
        tail = tail.next
      end
      tail.next = l1_current || l2_current
      dummy.next
    end
  end
end