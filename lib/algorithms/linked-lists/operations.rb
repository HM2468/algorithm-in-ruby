module Algorithms
  module LinkedLists
    def reverse_linked_list(head)
      return nil if head.nil?

      prev = nil
      current = head
      while current
        nxt = current.next   # 1. 保存下一个节点
        current.next = prev  # 2. 反转当前节点指针
        prev = current       # 3. 向前移动 prev 和 current
        current = nxt
      end
      prev
    end

  end
end