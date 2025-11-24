# spec/algorithms/binary_tree/bfs_spec.rb

require "spec_helper"

RSpec.describe Algorithms::BinaryTree do
  include described_class
  let(:node) { described_class::Node }

  describe '.bfs' do
    context 'when tree is empty' do
      it 'returns an empty array' do
        expect(bfs(nil)).to eq([])
      end
    end

    context 'when tree has only root node' do
      it 'returns an array with single value' do
        root = node.new(1, nil, nil)
        result = bfs(root)
        expect(result).to eq([1])
      end
    end

    context 'when tree is a complete binary tree' do
      #
      #        1
      #      /   \
      #     2     3
      #    / \   / \
      #   4   5 6   7
      #
      it 'traverses level by level from left to right' do
        n4 = node.new(4, nil, nil)
        n5 = node.new(5, nil, nil)
        n6 = node.new(6, nil, nil)
        n7 = node.new(7, nil, nil)
        n2 = node.new(2, n4, n5)
        n3 = node.new(3, n6, n7)
        root = node.new(1, n2, n3)

        result = bfs(root)

        expect(result).to eq([1, 2, 3, 4, 5, 6, 7])
      end
    end

    context 'when tree is left-skewed' do
      #
      #   1
      #  /
      # 2
      #  \
      #   3
      #
      it 'visits nodes in correct BFS order' do
        n3 = node.new(3, nil, nil)
        n2 = node.new(2, nil, n3)
        root = node.new(1, n2, nil)
        result = bfs(root)

        # BFS: 1 -> 2 -> 3
        expect(result).to eq([1, 2, 3])
      end
    end

    context 'when tree is right-skewed' do
      #
      #  1
      #   \
      #    2
      #     \
      #      3
      #
      it 'visits nodes level by level even if only right children exist' do
        n3 = node.new(3, nil, nil)
        n2 = node.new(2, nil, n3)
        root = node.new(1, nil, n2)
        result = bfs(root)
        expect(result).to eq([1, 2, 3])
      end
    end

    context 'when tree has missing children (non-complete)' do
      #
      #       'a'
      #      /   \
      #   'b'     'c'
      #    \      /
      #    'd'  'e'
      #
      it 'still follows left-to-right order at each level' do
        d = node.new('d', nil, nil)
        e = node.new('e', nil, nil)
        b = node.new('b', nil, d)
        c = node.new('c', e, nil)
        root = node.new('a', b, c)
        result = bfs(root)

        # Level 0: a
        # Level 1: b, c
        # Level 2: d, e  (b.left is nil, but that不影响顺序)
        expect(result).to eq(%w[a b c d e])
      end
    end

    context 'when node values are different types' do
      it 'handles strings, numbers or any objects as values' do
        obj = Object.new
        left  = node.new('left', nil, nil)
        right = node.new(obj, nil, nil)
        root  = node.new(42, left, right)
        result = bfs(root)

        expect(result).to eq([42, 'left', obj])
      end
    end

    context 'structure safety' do
      it 'does not modify the original tree structure' do
        n4 = node.new(4, nil, nil)
        n5 = node.new(5, nil, nil)
        n2 = node.new(2, n4, n5)
        n3 = node.new(3, nil, nil)
        root = node.new(1, n2, n3)

        # 记录原始结构
        original_left  = root.left
        original_right = root.right
        original_left_left  = root.left.left
        original_left_right = root.left.right

        bfs(root)

        # 确保 BFS 没有把指针乱改
        expect(root.left).to eq(original_left)
        expect(root.right).to eq(original_right)
        expect(root.left.left).to eq(original_left_left)
        expect(root.left.right).to eq(original_left_right)
      end
    end
  end
end