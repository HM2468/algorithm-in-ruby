module DataStructure
  module LinkedLists
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