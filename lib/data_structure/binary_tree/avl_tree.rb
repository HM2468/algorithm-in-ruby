module DataStructure
  module BinaryTree
    # 教科书风格的 AVL 平衡二叉搜索树
    class AvlTree
      attr_reader :root

      # 可选传入数组，依次插入构造一棵 AVL 树
      def initialize(values = [])
        @root = nil
        values.each { |v| insert(v) }
      end

      # --------- 查找 ---------
      def search(val)
        node = @root
        while node
          return node if val == node.val
          node = val < node.val ? node.left : node.right
        end
        nil
      end

      def include?(val)
        !!search(val)
      end

      # --------- 插入 ---------
      def insert(val)
        @root = insert_node(@root, val)
      end

      # --------- 更新（删旧值再插新值） ---------
      def update(old_val, new_val)
        return false unless include?(old_val)

        delete(old_val)
        insert(new_val)
        true
      end

      # --------- 删除 ---------
      # 返回是否删除成功（true/false）
      def delete(val)
        @root, deleted = delete_node(@root, val)
        deleted
      end

      private

      # ========== 辅助方法：高度 & 平衡因子 ==========

      # 空节点高度视为 0
      def node_height(node)
        node ? node.height : 0
      end

      # 用左右子树高度更新当前节点高度
      def update_height(node)
        left_h  = node_height(node.left)
        right_h = node_height(node.right)
        node.height = [left_h, right_h].max + 1
      end

      # 平衡因子 = 左子树高度 - 右子树高度
      def balance_factor(node)
        node_height(node.left) - node_height(node.right)
      end

      # ========== 旋转操作（AVL 标准写法） ==========

      # 右旋:
      #       y                 x
      #      / \               / \
      #     x   T3   ==>      T1  y
      #    / \                   / \
      #   T1 T2                 T2 T3
      def right_rotate(y)
        x  = y.left
        t2 = x.right

        # 旋转
        x.right = y
        y.left  = t2

        # 先更新下面的 y，再更新 x
        update_height(y)
        update_height(x)

        x
      end

      # 左旋:
      #     x                    y
      #    / \                  / \
      #   T1  y      ==>       x  T3
      #      / \              / \
      #     T2 T3            T1 T2
      def left_rotate(x)
        y  = x.right
        t2 = y.left

        # 旋转
        y.left  = x
        x.right = t2

        # 先更新下面的 x，再更新 y
        update_height(x)
        update_height(y)

        y
      end

      # 对当前节点做平衡处理（根据平衡因子决定做什么旋转）
      def rebalance(node)
        bf = balance_factor(node)

        # 左重
        if bf > 1
          # 左子树是右重 → 先对左子树左旋，再对自己右旋（LR 型）
          if balance_factor(node.left) < 0
            node.left = left_rotate(node.left)
          end
          return right_rotate(node)
        end

        # 右重
        if bf < -1
          # 右子树是左重 → 先对右子树右旋，再对自己左旋（RL 型）
          if balance_factor(node.right) > 0
            node.right = right_rotate(node.right)
          end
          return left_rotate(node)
        end

        node
      end

      # ========== 插入（递归） ==========

      def insert_node(node, val)
        # 普通 BST 插入逻辑
        if node.nil?
          # 新节点高度为 1
          return HeightNode.new(val, nil, nil, 1)
        end

        if val < node.val
          node.left  = insert_node(node.left, val)
        elsif val > node.val
          node.right = insert_node(node.right, val)
        else
          # 这里选择忽略重复值（也可以改成计数逻辑）
          return node
        end

        # 插入完成后，从下往上更新高度 + 平衡
        update_height(node)
        rebalance(node)
      end

      # ========== 删除（递归） ==========

      # 返回 [新子树根节点, 是否删除成功]
      def delete_node(node, val)
        return [nil, false] if node.nil?

        deleted = false

        if val < node.val
          node.left,  deleted = delete_node(node.left, val)
        elsif val > node.val
          node.right, deleted = delete_node(node.right, val)
        else
          # 找到要删的节点
          deleted = true

          # 只有一个子树或没有子树
          if node.left.nil? || node.right.nil?
            node = node.left || node.right
            # 直接返回（这里 node 可能为 nil，也可能是单子树）
            return [node, true]
          else
            # 左右子树都存在：
            # 找右子树中的最小节点（中序后继）
            successor = min_node(node.right)
            # 用后继值覆盖当前节点
            node.val = successor.val
            # 在右子树中删除这个后继值
            node.right, _ = delete_node(node.right, successor.val)
          end
        end

        # 如果删完变成空树，直接返回
        return [nil, deleted] if node.nil?

        # 更新高度 + 平衡
        update_height(node)
        [rebalance(node), deleted]
      end

      # 找到以 node 为根的最小值节点（一路向左）
      def min_node(node)
        current = node
        current = current.left while current.left
        current
      end
    end
  end
end