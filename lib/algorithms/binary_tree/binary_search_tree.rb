module Algorithms
  module BinaryTree

    class BinarySearchTree
      attr_reader :root

      # 可选地接收一个数组，依次插入构建 BST
      def initialize(values = [])
        @root = nil
        values.each { |v| insert(v) }
      end

      # --------- 增：插入 ---------
      def insert(val)
        @root = insert_node(@root, val)
      end

      # --------- 查：查找节点 ---------
      # 找到返回 Node，找不到返回 nil
      def search(val)
        node = @root
        while node
          return node if val == node.val
          node = val < node.val ? node.left : node.right
        end
        nil
      end

      # 语义友好的封装：是否包含某个值
      def include?(val)
        !!search(val)
      end

      # --------- 改：更新节点值 ---------
      # 这里用最简单粗暴的方式：
      #   先删掉 old_val，再插入 new_val
      # 返回 true/false 表示是否更新成功
      def update(old_val, new_val)
        return false unless include?(old_val)

        delete(old_val)
        insert(new_val)
        true
      end

      # --------- 删：删除节点 ---------
      # 返回 true/false 表示是否真的删到了这个值
      def delete(val)
        @root, deleted = delete_node(@root, val)
        deleted
      end

      private

      # 递归插入
      def insert_node(node, val)
        return Node.new(val) if node.nil?

        if val < node.val
          node.left  = insert_node(node.left, val)
        elsif val > node.val
          node.right = insert_node(node.right, val)
        else
          # val == node.val 的情况：
          # 这里选择“忽略重复值”，也可以改成计数等
        end

        node
      end

      # 递归删除，返回 [新的子树根节点, 是否删除成功]
      def delete_node(node, val)
        return [nil, false] if node.nil?

        if val < node.val
          node.left, deleted = delete_node(node.left, val)
          return [node, deleted]
        elsif val > node.val
          node.right, deleted = delete_node(node.right, val)
          return [node, deleted]
        else
          # 找到了要删除的节点 node

          # 情况 1：只有右子树或没有子树
          if node.left.nil?
            return [node.right, true]
          # 情况 2：只有左子树
          elsif node.right.nil?
            return [node.left, true]
          else
            # 情况 3：左右子树都在
            # 用「右子树中的最小值」当后继节点（successor）
            successor = node.right
            successor = successor.left while successor.left

            # 用后继的值覆盖当前节点
            node.val = successor.val
            # 然后在右子树中删掉“那个后继值”
            node.right, _ = delete_node(node.right, successor.val)

            return [node, true]
          end
        end
      end

    end
  end
end