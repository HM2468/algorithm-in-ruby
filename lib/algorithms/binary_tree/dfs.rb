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
      def preorder(root, &block)
        raise ArgumentError, 'no block given' unless block
        return if root.nil?

        block.call(root.val)
        preorder(root.left, &block)
        preorder(root.right, &block)
      end

      # 中序遍历：L -> D -> R
      def inorder(root, &block)
        raise ArgumentError, 'no block given' unless block
        return if root.nil?

        inorder(root.left, &block)
        block.call(root.val)
        inorder(root.right, &block)
      end

      # 后序遍历：L -> R -> D
      def postorder(root, &block)
        raise ArgumentError, 'no block given' unless block
        return if root.nil?

        postorder(root.left, &block)
        postorder(root.right, &block)
        block.call(root.val)
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

        # 技巧：用“变形前序遍历” + 反转
        # 正常前序是 D L R，这里改成 D R L，最后 reverse 一下就是 L R D
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