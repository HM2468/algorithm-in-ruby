module DataStructure
  module BinaryTree

    # 广度优先遍历 / 层序遍历
    # 返回一个按 BFS 顺序排列的节点值数组
    def bfs(root)
      return [] if root.nil?
      raise ArgumentError, 'Not a BinaryTree::Node' unless root.is_a?(Node)

      result = []
      q = LinkedQueue::Queue.new
      q.enqueue(root)

      while !q.empty?
        node = q.dequeue
        result << node.val

        q.enqueue(node.left) if node.left
        q.enqueue(node.right) if node.right
      end
      result
    end

  end
end