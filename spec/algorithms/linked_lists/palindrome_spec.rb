# spec/algorithms/linked_lists/palindrome_spec.rb
require "spec_helper"

RSpec.describe '#palindrome?' do
  include Algorithms::LinkedLists

  describe '#palindrome?' do
    it 'returns true for empty list' do
      head = nil
      expect(palindrome?(head)).to eq(true)
    end

    it 'returns true for single node' do
      head = build_linked_list([1])
      expect(palindrome?(head)).to eq(true)
    end

    it 'returns true for even-length palindrome' do
      head = build_linked_list([1, 2, 2, 1])
      expect(palindrome?(head)).to eq(true)
    end

    it 'returns true for odd-length palindrome' do
      head = build_linked_list([1, 2, 3, 2, 1])
      expect(palindrome?(head)).to eq(true)
    end

    it 'returns false for non-palindrome' do
      head = build_linked_list([1, 2])
      expect(palindrome?(head)).to eq(false)
    end

    it 'returns false for longer non-palindrome' do
      head = build_linked_list([1, 2, 3, 4, 2, 1])
      expect(palindrome?(head)).to eq(false)
    end

    it 'handles list with duplicate values not in palindrome order' do
      head = build_linked_list([1, 1, 2, 1])
      expect(palindrome?(head)).to eq(false)
    end
  end
end