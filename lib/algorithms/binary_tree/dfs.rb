=begin
    ### 二叉树的深度优先遍历（DFS Depth-First Search）
    深度优先遍历有三种常见方式：
    D=>Data, L=>Left Subtree, R=>Right Subtree
    - 前序遍历（Preorder）：D -> L -> R
    - 中序遍历（Inorder）：L -> D -> R
    - 后序遍历（Postorder）：L -> R -> D
=end

module Algorithms
  module BinaryTree

    module RecursionDFS
      # 前序遍历：D -> L -> R
      def preorder(root)
        return [] if root.nil?

        result = []
        result << root.val                  # 1. 访问D
        result.concat(preorder(root.left))  # 2. 遍历L子树
        result.concat(preorder(root.right)) # 3. 遍历R子树
        result
      end

      # 中序遍历：L -> D -> R
      def inorder(root)
        return [] if root.nil?

        result = []
        result.concat(inorder(root.left))   # 1. 遍历L子树
        result << root.val                  # 2. 访问D
        result.concat(inorder(root.right))  # 3. 遍历R子树
        result
      end

      # 后序遍历：L -> R -> D
      def postorder(root)
        return [] if root.nil?

        result = []
        result.concat(postorder(root.left))  # 1. 遍历L子树
        result.concat(postorder(root.right)) # 2. 遍历R子树
        result << root.val                   # 3. 最后访问D
        result
      end
    end

    module IterationDFS
      # 前序遍历：D -> L -> R
      def preorder(root)
        return [] if root.nil?

        result = []
        stack = LinkedStack::Stack.new
        stack.push(root)

        until stack.empty?
          node = stack.pop
          result << node.val

          # 先右后左入栈，这样出栈时就是先左后右
          stack.push(node.right) if node.right
          stack.push(node.left) if node.left
        end

        result
      end

      # 中序遍历：L -> D -> R
      def inorder(root)
        return [] if root.nil?

        result = []
        stack = LinkedStack::Stack.new
        current = root

        while current || !stack.empty?
          # 一直往左走，把沿途节点都压栈
          while current
            stack.push(current)
            current = current.left
          end

          # 左子树走到头了，弹出栈顶节点，访问它，然后转向右子树
          current = stack.pop
          result << current.val
          current = current.right
        end

        result
      end

      # 后序遍历：L -> R -> D
      def postorder(root)
        return [] if root.nil?

        result = []
        stack = LinkedStack::Stack.new
        stack.push(root)

        until stack.empty?
          node = stack.pop
          result << node.val

          # 先左后右入栈，这样出栈时就是后右先左
          stack.push(node.left) if node.left
          stack.push(node.right) if node.right
        end

        result.reverse
      end
    end
  end
end