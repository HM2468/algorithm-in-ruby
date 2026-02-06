module DataStructure
  module LinkedLists
    # 递归打印链表
    def recursive_print(head)
      return if head.nil?
      print "#{head.val} -> "
      recursive_print(head.next)
    end
  end
end