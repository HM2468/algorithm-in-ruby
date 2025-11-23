module Algorithms
  module BinaryTree
=begin
    ### 二叉树的深度优先遍历（DFS Depth-First Search）
    深度优先遍历有三种常见方式：
    D=>Data, L=>Left Subtree, R=>Right Subtree
    - 前序遍历（Preorder）：D -> L -> R
    - 中序遍历（Inorder）：L -> D -> R
    - 后序遍历（Postorder）：L -> R -> D
=end

    # 前序遍历：D -> L -> R
    def preorder_recursively(root)
      return [] if root.nil?

      result = []
      result << root.val                  # 1. 访问D
      result.concat(preorder(root.left))  # 2. 遍历L子树
      result.concat(preorder(root.right)) # 3. 遍历R子树
      result
    end

    # 中序遍历：L -> D -> R
    def inorder_recursively(root)
      return [] if root.nil?

      result = []
      result.concat(inorder(root.left))   # 1. 遍历L子树
      result << root.val                  # 2. 访问D
      result.concat(inorder(root.right))  # 3. 遍历R子树
      result
    end

    # 后序遍历：L -> R -> D
    def postorder_recursively(root)
      return [] if root.nil?

      result = []
      result.concat(postorder(root.left))  # 1. 遍历L子树
      result.concat(postorder(root.right)) # 2. 遍历R子树
      result << root.val                   # 3. 最后访问D
      result
    end
  end
end