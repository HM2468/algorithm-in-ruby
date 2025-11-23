# spec/algorithms/linked_lists/reverse_linked_list_spec.rb
require "spec_helper"

RSpec.describe 'reverse_linked_list' do
  include Algorithms::LinkedLists

  describe '#reverse_linked_list' do
    context 'when the head is nil (empty list)' do
      it 'returns nil' do
        head = nil
        reversed = reverse_linked_list(head)
        expect(reversed).to be_nil
      end
    end

    context 'when the list has only one node' do
      it 'returns the same node as head' do
        head     = build_linked_list([42])
        reversed = reverse_linked_list(head)

        expect(reversed).to equal(head)      # 同一个对象
        expect(list_to_array(reversed)).to eq([42])
        expect(reversed.next).to be_nil
      end
    end

    context 'when the list has multiple nodes' do
      it 'reverses the order of nodes' do
        head     = build_linked_list([1, 2, 3, 4, 5])
        reversed = reverse_linked_list(head)

        expect(list_to_array(reversed)).to eq([5, 4, 3, 2, 1])
      end

      it 'makes the original head become the tail (next = nil)' do
        head           = build_linked_list([10, 20, 30])
        original_head  = head
        reversed       = reverse_linked_list(head)

        # 找到翻转后链表的最后一个节点
        tail = reversed
        tail = tail.next while tail.next

        expect(tail).to equal(original_head)
        expect(tail.next).to be_nil
      end
    end

    context 'when the list contains duplicate values' do
      it 'still reverses correctly and preserves all values' do
        head     = build_linked_list([1, 1, 2, 3, 3])
        reversed = reverse_linked_list(head)

        expect(list_to_array(reversed)).to eq([3, 3, 2, 1, 1])
      end
    end

    context 'when the list contains negative and zero values' do
      it 'reverses correctly' do
        head     = build_linked_list([-1, 0, 1, 2])
        reversed = reverse_linked_list(head)

        expect(list_to_array(reversed)).to eq([2, 1, 0, -1])
      end
    end

    it 'does not create new nodes (reuses the existing nodes)' do
      head = build_linked_list([1, 2, 3, 4])
      before_ids = node_object_ids(head)

      reversed = reverse_linked_list(head)
      after_ids = node_object_ids(reversed)

      # 翻转前后，节点集合相同（只是顺序变了）
      expect(after_ids.sort).to eq(before_ids.sort)
    end

    it 'reverses the list in-place so that reversing twice restores the original order' do
      head = build_linked_list([1, 2, 3, 4, 5])

      first_reverse  = reverse_linked_list(head)
      second_reverse = reverse_linked_list(first_reverse)

      expect(list_to_array(second_reverse)).to eq([1, 2, 3, 4, 5])
    end
  end
end