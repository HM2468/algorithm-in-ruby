# spec/data_structure/linked_stack/mini_stack_spec.rb
require 'spec_helper'
RSpec.describe DataStructure::LinkedStack::MinStack do
  subject(:min_stack) { described_class.new }

  describe 'initial state' do
    it 'can be instantiated without error' do
      expect { min_stack }.not_to raise_error
    end

    it 'is empty initially if #empty? is defined' do
      if min_stack.respond_to?(:empty?)
        expect(min_stack.empty?).to be true
      end
    end

    it 'returns nil for top on empty stack' do
      expect(min_stack.top).to be_nil
    end

    it 'returns nil for get_min on empty stack' do
      expect(min_stack.get_min).to be_nil
    end

    it 'returns nil for pop on empty stack' do
      expect(min_stack.pop).to be_nil
    end
  end

  describe '#push and #get_min' do
    it 'returns pushed value as min when only one element' do
      min_stack.push(5)
      expect(min_stack.top).to eq(5)
      expect(min_stack.get_min).to eq(5)
    end

    it 'tracks minimum correctly with increasing values' do
      values = [1, 2, 3, 4, 5]
      values.each { |v| min_stack.push(v) }

      expect(min_stack.top).to eq(5)
      expect(min_stack.get_min).to eq(1)
    end

    it 'tracks minimum correctly with decreasing values' do
      values = [5, 4, 3, 2, 1]
      values.each { |v| min_stack.push(v) }

      expect(min_stack.top).to eq(1)
      expect(min_stack.get_min).to eq(1)
    end

    it 'tracks minimum correctly with mixed values and duplicates' do
      values = [3, 5, 2, 2, 4]
      expected_mins = [3, 3, 2, 2, 2]

      values.each_with_index do |v, i|
        min_stack.push(v)
        expect(min_stack.get_min).to eq(expected_mins[i])
      end
    end

    it 'handles negative numbers and zero correctly' do
      values = [0, -1, 5, -3, 2]
      expected_mins = [0, -1, -1, -3, -3]

      values.each_with_index do |v, i|
        min_stack.push(v)
        expect(min_stack.get_min).to eq(expected_mins[i])
      end
    end
  end

  describe '#pop and #get_min' do
    context 'when there are no duplicate minimum values' do
      before do
        # 从大到小推，这样最后的最小值在栈顶
        [5, 4, 3, 2, 1].each { |v| min_stack.push(v) }
      end

      it 'updates top and min correctly when popping elements' do
        expect(min_stack.top).to eq(1)
        expect(min_stack.get_min).to eq(1)

        # pop 1
        expect(min_stack.pop).to eq(1)
        expect(min_stack.top).to eq(2)
        expect(min_stack.get_min).to eq(2)

        # pop 2
        expect(min_stack.pop).to eq(2)
        expect(min_stack.top).to eq(3)
        expect(min_stack.get_min).to eq(3)
      end
    end

    context 'when there are duplicate minimum values' do
      before do
        # 中间有多个 2
        [3, 2, 2, 4, 1, 1].each { |v| min_stack.push(v) }
      end

      it 'keeps the correct minimum after popping non-min elements' do
        # 当前栈顶为 1，最小值也为 1
        expect(min_stack.get_min).to eq(1)

        # 弹出 1（栈顶）
        expect(min_stack.pop).to eq(1)
        expect(min_stack.get_min).to eq(1) # 还有一个 1

        # 再弹出 1
        expect(min_stack.pop).to eq(1)
        # 现在最小值变回 2
        expect(min_stack.get_min).to eq(2)

        # 再弹 4
        expect(min_stack.pop).to eq(4)
        expect(min_stack.get_min).to eq(2)

        # 再弹一个 2
        expect(min_stack.pop).to eq(2)
        expect(min_stack.get_min).to eq(2)

        # 再弹最后一个 2
        expect(min_stack.pop).to eq(2)
        expect(min_stack.get_min).to eq(3)
      end
    end

    context 'when stack becomes empty after popping all elements' do
      it 'returns nil for top and get_min' do
        [2, 1].each { |v| min_stack.push(v) }

        expect(min_stack.pop).to eq(1)
        expect(min_stack.pop).to eq(2)
        expect(min_stack.pop).to be_nil

        expect(min_stack.top).to be_nil
        expect(min_stack.get_min).to be_nil

        if min_stack.respond_to?(:empty?)
          expect(min_stack.empty?).to be true
        end
      end
    end
  end

  describe 'interleaved push/pop/top/get_min' do
    it 'handles mixed operations correctly' do
      min_stack.push(3)
      expect(min_stack.get_min).to eq(3)
      expect(min_stack.top).to eq(3)

      min_stack.push(5)
      expect(min_stack.get_min).to eq(3)
      expect(min_stack.top).to eq(5)

      min_stack.push(2)
      expect(min_stack.get_min).to eq(2)
      expect(min_stack.top).to eq(2)

      expect(min_stack.pop).to eq(2)
      expect(min_stack.get_min).to eq(3)
      expect(min_stack.top).to eq(5)

      min_stack.push(1)
      expect(min_stack.get_min).to eq(1)
      expect(min_stack.top).to eq(1)

      expect(min_stack.pop).to eq(1)
      expect(min_stack.get_min).to eq(3)
      expect(min_stack.top).to eq(5)

      expect(min_stack.pop).to eq(5)
      expect(min_stack.get_min).to eq(3)
      expect(min_stack.top).to eq(3)

      expect(min_stack.pop).to eq(3)
      expect(min_stack.top).to be_nil
      expect(min_stack.get_min).to be_nil
    end
  end

  describe 'stress test with many operations' do
    it 'keeps get_min consistent with Ruby Array#min' do
      values = []
      200.times do |i|
        val = (i % 7) - 3  # 生成一些有重复的正负值
        min_stack.push(val)
        values << val
        expect(min_stack.get_min).to eq(values.min)
      end

      # 再逐个 pop，验证每一步的最小值
      while (last = values.pop)
        # 当前 get_min 应当等于 values.min（如果 values 不空）
        if values.empty?
          expect(min_stack.pop).to eq(last)
          expect(min_stack.get_min).to be_nil
        else
          expect(min_stack.get_min).to eq(values.min)
          expect(min_stack.pop).to eq(last)
        end
      end

      expect(min_stack.top).to be_nil
      expect(min_stack.get_min).to be_nil
    end
  end
end