# spec/algorithms/linked_lists/reverse_k_group_spec.rb

require "spec_helper"

RSpec.describe 'reverse_k_group' do
  include Algorithms::LinkedLists

  describe '#reverse_k_group' do
    it 'returns nil when head is nil' do
      head = nil
      expect(reverse_k_group(head, 2)).to be_nil
    end

    it 'returns original list when k <= 1' do
      head = build_linked_list([1, 2, 3])
      new_head = reverse_k_group(head, 1)
      expect(list_to_array(new_head)).to eq([1, 2, 3])
    end

    it 'reverses nodes in groups of k when length is multiple of k' do
      head = build_linked_list([1, 2, 3, 4])
      new_head = reverse_k_group(head, 2)
      expect(list_to_array(new_head)).to eq([2, 1, 4, 3])
    end

    it 'reverses nodes in groups of k and keeps remaining nodes as is' do
      head = build_linked_list([1, 2, 3, 4, 5])
      new_head = reverse_k_group(head, 2)
      expect(list_to_array(new_head)).to eq([2, 1, 4, 3, 5])
    end

    it 'reverses 7 nodes k = 3' do
      head = build_linked_list([1,2,3,4,5,6,7,8])
      new_head = reverse_k_group(head, 3)
      expect(list_to_array(new_head)).to eq([3,2,1,6,5,4,7,8])
    end

    it 'reverses nodes in group of 3 correctly' do
      head = build_linked_list([1, 2, 3, 4, 5])
      new_head = reverse_k_group(head, 3)
      expect(list_to_array(new_head)).to eq([3, 2, 1, 4, 5])
    end

    it 'does not change list when k greater than length' do
      head = build_linked_list([1, 2])
      new_head = reverse_k_group(head, 3)
      expect(list_to_array(new_head)).to eq([1, 2])
    end

    it 'works for single-element list' do
      head = build_linked_list([42])
      new_head = reverse_k_group(head, 2)
      expect(list_to_array(new_head)).to eq([42])
    end
  end
end