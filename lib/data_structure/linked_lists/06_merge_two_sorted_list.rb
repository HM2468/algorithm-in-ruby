=begin
21. Merge Two Sorted Lists
l1, l2 都是升序链表，返回升序合并后的头结点
循环条件 l1_current && l2_current：两条都还有节点时才需要比较。每轮：
  1.	比较 l1_current.val 和 l2_current.val
  2.	把较小的那个接到 tail.next
  3.	被接走的那条链表指针前进
  4.	tail 前进到新接上的节点
=end

module DataStructure
  module LinkedLists
    def merge_two_sorted_lists(l1, l2)
      dummy = Node.new(nil, nil)
      res_tail = dummy
      l1_current = l1
      l2_current = l2
      while l1_current && l2_current
        if l1_current.val <= l2_current.val
          res_tail.next = l1_current
          l1_current = l1_current.next
        else
          res_tail.next = l2_current
          l2_current = l2_current.next
        end
        res_tail = res_tail.next
      end
      res_tail.next = l1_current || l2_current
      dummy.next
    end
  end
end