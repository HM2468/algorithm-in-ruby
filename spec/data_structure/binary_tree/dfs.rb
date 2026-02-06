# spec/data_structure/binary_tree/dfs_spec.rb
require "spec_helper"

RSpec.describe DataStructure::BinaryTree do
  let(:node) { described_class::Node }

  let(:iteration) do
    Class.new do
      include DataStructure::BinaryTree::IterationDFS
    end.new
  end

  let(:recursion) do
    Class.new do
      include DataStructure::BinaryTree::RecursionDFS
    end.new
  end

  describe 'DFS traversals (preorder / inorder / postorder)' do
    context 'when the tree is empty (root is nil)' do
      let(:root) { nil }

      it 'returns an empty array for all traversals' do
        # 迭代版
        expect(iteration.preorder(root)).to  eq([])
        expect(iteration.inorder(root)).to   eq([])
        expect(iteration.postorder(root)).to eq([])

        # 递归版（block 收集结果）
        pre_vals  = []
        in_vals   = []
        post_vals = []

        recursion.preorder(root)  { |v| pre_vals  << v }
        recursion.inorder(root)   { |v| in_vals   << v }
        recursion.postorder(root) { |v| post_vals << v }

        expect(pre_vals).to  eq([])
        expect(in_vals).to   eq([])
        expect(post_vals).to eq([])
      end
    end

    context 'when the tree has only one node' do
      let(:root) { node.new(1, nil, nil) }

      it 'returns [1] for all traversals' do
        # 迭代版
        expect(iteration.preorder(root)).to  eq([1]) # D
        expect(iteration.inorder(root)).to   eq([1]) # D
        expect(iteration.postorder(root)).to eq([1]) # D

        # 递归版
        pre_vals  = []
        in_vals   = []
        post_vals = []

        recursion.preorder(root)  { |v| pre_vals  << v }
        recursion.inorder(root)   { |v| in_vals   << v }
        recursion.postorder(root) { |v| post_vals << v }

        expect(pre_vals).to  eq([1])
        expect(in_vals).to   eq([1])
        expect(post_vals).to eq([1])
      end
    end

    context 'when the tree is a more complex binary tree' do
      #          1
      #        /   \
      #       2     3
      #      / \   /
      #     4   5 6
      #
      # preorder:  [1, 2, 4, 5, 3, 6]
      # inorder:   [4, 2, 5, 1, 6, 3]
      # postorder: [4, 5, 2, 6, 3, 1]
      let(:root) do
        n4 = node.new(4, nil, nil)
        n5 = node.new(5, nil, nil)
        n6 = node.new(6, nil, nil)
        n2 = node.new(2, n4, n5)
        n3 = node.new(3, n6, nil)
        node.new(1, n2, n3)
      end

      it 'visits nodes in correct order for all three traversals' do
        # 迭代版
        expect(iteration.preorder(root)).to  eq([1, 2, 4, 5, 3, 6])
        expect(iteration.inorder(root)).to   eq([4, 2, 5, 1, 6, 3])
        expect(iteration.postorder(root)).to eq([4, 5, 2, 6, 3, 1])

        # 递归版
        pre_vals  = []
        in_vals   = []
        post_vals = []

        recursion.preorder(root)  { |v| pre_vals  << v }
        recursion.inorder(root)   { |v| in_vals   << v }
        recursion.postorder(root) { |v| post_vals << v }

        expect(pre_vals).to  eq([1, 2, 4, 5, 3, 6])
        expect(in_vals).to   eq([4, 2, 5, 1, 6, 3])
        expect(post_vals).to eq([4, 5, 2, 6, 3, 1])
      end
    end

    context 'when the tree is right-skewed (only right children)' do
      # 1
      #  \
      #   2
      #    \
      #     3
      #
      # preorder:  [1, 2, 3]
      # inorder:   [1, 2, 3]
      # postorder: [3, 2, 1]
      let(:root) do
        n3 = node.new(3, nil, nil)
        n2 = node.new(2, nil, n3)
        node.new(1, nil, n2)
      end

      it 'returns correct traversal orders for a right-skewed tree' do
        # 迭代版
        expect(iteration.preorder(root)).to  eq([1, 2, 3])
        expect(iteration.inorder(root)).to   eq([1, 2, 3])
        expect(iteration.postorder(root)).to eq([3, 2, 1])

        # 递归版
        pre_vals  = []
        in_vals   = []
        post_vals = []

        recursion.preorder(root)  { |v| pre_vals  << v }
        recursion.inorder(root)   { |v| in_vals   << v }
        recursion.postorder(root) { |v| post_vals << v }

        expect(pre_vals).to  eq([1, 2, 3])
        expect(in_vals).to   eq([1, 2, 3])
        expect(post_vals).to eq([3, 2, 1])
      end
    end

    context 'when the tree is left-skewed (only left children)' do
      #     1
      #    /
      #   2
      #  /
      # 3
      #
      # preorder:  [1, 2, 3]
      # inorder:   [3, 2, 1]
      # postorder: [3, 2, 1]
      let(:root) do
        n3 = node.new(3, nil, nil)
        n2 = node.new(2, n3, nil)
        node.new(1, n2, nil)
      end

      it 'returns correct traversal orders for a left-skewed tree' do
        # 迭代版
        expect(iteration.preorder(root)).to  eq([1, 2, 3])
        expect(iteration.inorder(root)).to   eq([3, 2, 1])
        expect(iteration.postorder(root)).to eq([3, 2, 1])

        # 递归版
        pre_vals  = []
        in_vals   = []
        post_vals = []

        recursion.preorder(root)  { |v| pre_vals  << v }
        recursion.inorder(root)   { |v| in_vals   << v }
        recursion.postorder(root) { |v| post_vals << v }

        expect(pre_vals).to  eq([1, 2, 3])
        expect(in_vals).to   eq([3, 2, 1])
        expect(post_vals).to eq([3, 2, 1])
      end
    end
  end
end