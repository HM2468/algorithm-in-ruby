# file: lib/algorithms/linked-lists/operations.rb

module Algorithms
  module LinkedLists

    # 206. Reverse Linked List
    # head: 头结点
    # 返回新的头结点
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


    # 判断链表是否为回文
    def palindrome?(head)
      # 空链表或单节点链表天然是回文
      return true if head.nil? || head.next.nil?
      # 1. 找到中间节点（slow）
      slow = head
      fast = head
      while fast && fast.next
        slow = slow.next
        fast = fast.next.next
      end
      # 走出循环时：
      # - 若 fast 为 nil：长度为偶数，slow 在“右半段的起点”
      # - 若 fast 不为 nil：长度为奇数，slow 在“正中间”，需要 slow 再往后挪一步跳过中点
      slow = slow.next if fast # 奇数长度，跳过中间节点
      # 2. 反转后半段
      second_half_reversed = reverse_linked_list(slow)
      # 3. 比较前半与“反转后的后半”
      p1 = head
      p2 = second_half_reversed
      while p2 # 只需比较后半段长度这么多
        return false if p1.val != p2.val
        p1 = p1.next
        p2 = p2.next
      end
      # 可选：再反转 second_half_reversed 还原原链表，这里略过
      true
    end

  end
end