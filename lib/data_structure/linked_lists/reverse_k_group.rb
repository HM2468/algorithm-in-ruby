# file: lib/DataStructure/linked-lists/reverse_k_group.rb

=begin
    ### 题目要点
    给定链表 head 和整数 k，每 k 个节点一组进行反转，并返回新的头结点。
    规则：
    - 每一段完整的 k 个节点反转
    - 如果最后剩余的节点数小于 k，保持原顺序不动
    - 只能修改节点指针，不能改变节点内部值
    例子：
    - 输入：1 -> 2 -> 3 -> 4 -> 5, k = 2
        输出：2 -> 1 -> 4 -> 3 -> 5
    - 输入：1 -> 2 -> 3 -> 4 -> 5, k = 3
        输出：3 -> 2 -> 1 -> 4 -> 5（最后 4 -> 5 不满 3 个，不动）
    ### 思路（理解为主）
    这是“链表反转 + 分段处理”的综合题，典型写法：
    1.  先弄一个 虚拟头结点 dummy，指向原始 head,  这样处理头一组的时候会方便很多。
        dummy = Node.new(nil, head)
        group_prev = dummy
    2.  对每一轮循环，先从 group_prev 开始，往前走 k 步，找到这一组的第 k 个节点 kth：
        - 如果中途就走到 nil，说明剩下节点不够一组 k 个，直接结束，返回 dummy.next。
        - 否则，group_prev.next 到 kth 这一段，就是当前要反转的区间。
    3.  记下 group_next = kth.next，表示下一组的起点。
    4.  把 [group_prev.next, kth] 这一段 原地反转：
        - 反转时，可以用“头插法”或普通 prev-curr-next 那种模板
        - 一个常用技巧是，让反转时以 group_next 为“终止哨兵”（反转到 curr == group_next 为止）
    5.  反转完一组后，重新连接：
        - group_prev.next 应该指向这组反转后的新头（原来的 kth, 现在的 prev）
        - 这组的尾结点变成反转前的 group_prev.next，把它记成 group_prev，用于下一轮
    6.  重复步骤 2～5，直到链表末尾或剩余节点不足 k。

    主要是理解“如何分组 + 每组内部怎么反转 + 指针如何重新接起来”这三个点。
    小心点的点：
    - while curr != group_next 这句：表示“反转到 kth 为止”，因为 group_next 是 kth.next。
    - 反转结束后，这一段链表的结构已经完全改了，prev 变成了新头。
    - old_group_head 是反转前这组的头（反转后它变成尾），刚好是下一组的 group_prev。

    重点看这几个指针：
    •	dummy：虚拟头结点，始终在最前面
    •	group_prev：当前组的前一个节点（第一组时就是 dummy）
    •	kth：当前组的第 k 个节点
    •	group_next：当前组结束后的第一个节点（下一组的起点）
    •	curr、prev：用于在当前组内部做原地反转

=end

module DataStructure
  module LinkedLists
    # 25. Reverse Nodes in k-Group
    # K 个一组反转链表
    def reverse_k_group(head, k)
      return head if head.nil? || k <= 1

      dummy = Node.new('dummy', head)
      group_prev = dummy
      loop do
        # 1. 从 group_prev 开始，找到当前组的第 k 个节点（kth）
        kth = group_prev
        k.times do
          kth = kth.next
          # 剩余节点不到 k 个，结束
          return dummy.next if kth.nil?
        end
        group_next = kth.next    # 下一组的起点
        prev = group_next        # 该组中原地反转后的尾节点的 next 指针，用于连接下一组
        curr = group_prev.next
        # 2. 反转 [group_prev.next, kth] 这一段
        while curr != group_next # “反转到 kth 为止”，因为 group_next 是 kth.next。
          nxt       = curr.next
          curr.next = prev
          prev      = curr
          curr      = nxt
        end
        # 3. 重新连接：
        # 现在 prev 是这一组反转后新的头节点
        old_group_head = group_prev.next # group_prev.next 原来是这一组旧的头节点，现在变成了尾节点
        group_prev.next = prev           # 连接上一组和当前组反转后的头节点（注意：第一组时就是dummy）
        group_prev = old_group_head      # 为下一轮准备：group_prev 移动到当前组的尾部
      end
    end
  end
end