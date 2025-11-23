# spec/algorithms/binary_tree/depth_first_traversal_spec.rb
require "spec_helper"

RSpec.describe 'Depth First Traversal Recursively' do
  include Algorithms::BinaryTree::Recursion

  describe '#preorder' do
    context 'when the tree is empty (root is nil)' do
      it 'returns an empty array' do
        expect(preorder(nil)).to eq([])
      end
    end

    context 'when the tree has only one Algorithms::BinaryTree::Node' do
      it 'returns an array with just the root value' do
        root = Algorithms::BinaryTree::Node.new(1, nil, nil)
        expect(preorder(root)).to eq([1])
      end
    end

    context 'when the tree is a more complex binary tree' do
      # 构造下面这棵树：
      #
      #          1
      #        /   \
      #       2     3
      #      / \   /
      #     4   5 6
      #
      # preorder:  D -> L -> R
      #            [1, 2, 4, 5, 3, 6]
      let(:root) do
        n4 = Algorithms::BinaryTree::Node.new(4, nil, nil)
        n5 = Algorithms::BinaryTree::Node.new(5, nil, nil)
        n6 = Algorithms::BinaryTree::Node.new(6, nil, nil)
        n2 = Algorithms::BinaryTree::Node.new(2, n4, n5)
        n3 = Algorithms::BinaryTree::Node.new(3, n6, nil)
        Algorithms::BinaryTree::Node.new(1, n2, n3)
      end

      it 'visits Algorithms::BinaryTree::Nodes in D-L-R order' do
        expect(preorder(root)).to eq([1, 2, 4, 5, 3, 6])
      end

      it 'visits Algorithms::BinaryTree::Nodes in L-D-R order' do
        expect(inorder(root)).to eq([4,2,5,1,6,3])
      end

      it 'visits Algorithms::BinaryTree::Nodes in L-R-D order' do
        expect(postorder(root)).to eq([4,5,2,6,3,1])
      end
    end

    context 'when the tree is left-skewed' do
      # 1
      #  \
      #   2
      #    \
      #     3
      let(:root) do
        n3 = Algorithms::BinaryTree::Node.new(3, nil, nil)
        n2 = Algorithms::BinaryTree::Node.new(2, nil, n3)
        Algorithms::BinaryTree::Node.new(1, nil, n2)
      end

      it 'still follows D-L-R (which degenerates to root-right chain)' do
        expect(preorder(root)).to eq([1, 2, 3])
      end
    end
  end

  describe '#inorder' do
    context 'when the tree is empty' do
      it 'returns an empty array' do
        expect(inorder(nil)).to eq([])
      end
    end

    context 'when the tree has only one Algorithms::BinaryTree::Node' do
      it 'returns an array with just the root value' do
        root = Algorithms::BinaryTree::Node.new(1, nil, nil)
        expect(inorder(root)).to eq([1])
      end
    end

    context 'when the tree is a more complex binary tree' do
      # 同一棵树：
      #
      #          1
      #        /   \
      #       2     3
      #      / \   /
      #     4   5 6
      #
      # inorder:  L -> D -> R
      #           [4, 2, 5, 1, 6, 3]
      let(:root) do
        n4 = Algorithms::BinaryTree::Node.new(4, nil, nil)
        n5 = Algorithms::BinaryTree::Node.new(5, nil, nil)
        n6 = Algorithms::BinaryTree::Node.new(6, nil, nil)
        n2 = Algorithms::BinaryTree::Node.new(2, n4, n5)
        n3 = Algorithms::BinaryTree::Node.new(3, n6, nil)
        Algorithms::BinaryTree::Node.new(1, n2, n3)
      end

      it 'visits Algorithms::BinaryTree::Nodes in L-D-R order' do
        expect(inorder(root)).to eq([4, 2, 5, 1, 6, 3])
      end
    end

    context 'when the tree is right-skewed' do
      # 1
      #  \
      #   2
      #    \
      #     3
      #
      # inorder 对“只有右孩子”的树来说也是 [1, 2, 3]
      let(:root) do
        n3 = Algorithms::BinaryTree::Node.new(3, nil, nil)
        n2 = Algorithms::BinaryTree::Node.new(2, nil, n3)
        Algorithms::BinaryTree::Node.new(1, nil, n2)
      end

      it 'returns Algorithms::BinaryTree::Nodes from top to bottom in order' do
        expect(inorder(root)).to eq([1, 2, 3])
      end
    end
  end

  describe '#postorder' do
    context 'when the tree is empty' do
      it 'returns an empty array' do
        expect(postorder(nil)).to eq([])
      end
    end

    context 'when the tree has only one Algorithms::BinaryTree::Node' do
      it 'returns an array with just the root value' do
        root = Algorithms::BinaryTree::Node.new(1, nil, nil)
        expect(postorder(root)).to eq([1])
      end
    end

    context 'when the tree is a more complex binary tree' do
      # 还是这棵树：
      #
      #          1
      #        /   \
      #       2     3
      #      / \   /
      #     4   5 6
      #
      # postorder:  L -> R -> D
      #             [4, 5, 2, 6, 3, 1]
      let(:root) do
        n4 = Algorithms::BinaryTree::Node.new(4, nil, nil)
        n5 = Algorithms::BinaryTree::Node.new(5, nil, nil)
        n6 = Algorithms::BinaryTree::Node.new(6, nil, nil)
        n2 = Algorithms::BinaryTree::Node.new(2, n4, n5)
        n3 = Algorithms::BinaryTree::Node.new(3, n6, nil)
        Algorithms::BinaryTree::Node.new(1, n2, n3)
      end

      it 'visits Algorithms::BinaryTree::Nodes in L-R-D order' do
        expect(postorder(root)).to eq([4, 5, 2, 6, 3, 1])
      end
    end

    context 'when the tree is left-skewed' do
      #     1
      #    /
      #   2
      #  /
      # 3
      #
      # postorder: [3, 2, 1]
      let(:root) do
        n3 = Algorithms::BinaryTree::Node.new(3, nil, nil)
        n2 = Algorithms::BinaryTree::Node.new(2, n3, nil)
        Algorithms::BinaryTree::Node.new(1, n2, nil)
      end

      it 'returns Algorithms::BinaryTree::Nodes from bottom to top' do
        expect(postorder(root)).to eq([3, 2, 1])
      end
    end
  end
end