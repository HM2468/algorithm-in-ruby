# spec/algorithms/sorting/sorting_spec.rb
require 'spec_helper'

RSpec.describe Algorithms::Sorting do
  # 用 helper class 来 include 模块方法
  let(:sorting_helper) do
    Class.new do
      include Algorithms::Sorting
    end.new
  end

  # 共享示例：同一组输入，对三种排序算法都做断言
  shared_examples 'a sorting suite' do |unsorted, expected_sorted|
    it "sorts #{unsorted.inspect} correctly with all algorithms" do
      # ------ bubble_sort! ------
      bubble_input  = unsorted.dup
      bubble_return = sorting_helper.bubble_sort!(bubble_input)

      expect(bubble_input).to  eq(expected_sorted)   # 原地排序结果正确
      expect(bubble_return).to equal(bubble_input)   # 返回值是同一个数组对象

      # ------ merge_sort ------
      merge_input  = unsorted.dup
      merge_return = sorting_helper.merge_sort(merge_input)

      expect(merge_return).to eq(expected_sorted)    # 返回的新数组排序正确
      expect(merge_input).to  eq(unsorted)           # 原数组不应被修改

      # ------ quick_sort! ------
      quick_input  = unsorted.dup
      quick_return = sorting_helper.quick_sort!(quick_input, 0, quick_input.length - 1)

      expect(quick_input).to  eq(expected_sorted)    # 原地排序结果正确
      expect(quick_return).to equal(quick_input)     # 返回值是同一个数组对象
    end
  end

  describe 'sorting algorithms: bubble_sort!, merge_sort, quick_sort!' do
    # --- 基础场景：小数据集 ---

    context 'when array is empty' do
      include_examples 'a sorting suite', [], []
    end

    context 'when array has one element' do
      include_examples 'a sorting suite', [1], [1]
    end

    context 'when array has two elements' do
      include_examples 'a sorting suite', [2, 1], [1, 2]
    end

    context 'when array is already sorted' do
      include_examples 'a sorting suite', [1, 2, 3, 4], [1, 2, 3, 4]
    end

    context 'when array is reverse sorted' do
      include_examples 'a sorting suite', [5, 4, 3, 2, 1], [1, 2, 3, 4, 5]
    end

    context 'when array contains duplicate elements' do
      include_examples 'a sorting suite', [3, 1, 2, 3, 2], [1, 2, 2, 3, 3]
    end

    context 'when array contains negative numbers' do
      include_examples 'a sorting suite', [-1, 5, 0, -3, 2], [-3, -1, 0, 2, 5]
    end

    context 'when array contains large and small integers mixed' do
      include_examples 'a sorting suite',
                       [1000, -50, 3, 999, 0, -1],
                       [-50, -1, 0, 3, 999, 1000]
    end

    # --- 稍大一点的固定数据集 ---

    context 'when array has 20 elements shuffled' do
      let(:unsorted) do
        # 固定种子，避免测试结果不稳定
        rng = Random.new(42)
        (1..20).to_a.shuffle(random: rng)
      end

      let(:expected_sorted) { (1..20).to_a }

      it 'sorts a 20-element shuffled array correctly with all algorithms' do
        # bubble_sort!
        bubble_input  = unsorted.dup
        bubble_return = sorting_helper.bubble_sort!(bubble_input)
        expect(bubble_input).to  eq(expected_sorted)
        expect(bubble_return).to equal(bubble_input)

        # merge_sort
        merge_input  = unsorted.dup
        merge_return = sorting_helper.merge_sort(merge_input)
        expect(merge_return).to eq(expected_sorted)
        expect(merge_input).to  eq(unsorted)

        # quick_sort!
        quick_input  = unsorted.dup
        quick_return = sorting_helper.quick_sort!(quick_input, 0, quick_input.length - 1)
        expect(quick_input).to  eq(expected_sorted)
        expect(quick_return).to equal(quick_input)
      end
    end

    context 'when array has 100 elements shuffled' do
      let(:unsorted) do
        rng = Random.new(2024)
        (1..100).to_a.shuffle(random: rng)
      end

      let(:expected_sorted) { (1..100).to_a }

      it 'sorts a 100-element shuffled array correctly with all algorithms' do
        # bubble_sort!（O(n^2)，100 还好，测试时间可接受）
        bubble_input  = unsorted.dup
        bubble_return = sorting_helper.bubble_sort!(bubble_input)
        expect(bubble_input).to  eq(expected_sorted)
        expect(bubble_return).to equal(bubble_input)

        # merge_sort
        merge_input  = unsorted.dup
        merge_return = sorting_helper.merge_sort(merge_input)
        expect(merge_return).to eq(expected_sorted)
        expect(merge_input).to  eq(unsorted)

        # quick_sort!
        quick_input  = unsorted.dup
        quick_return = sorting_helper.quick_sort!(quick_input, 0, quick_input.length - 1)
        expect(quick_input).to  eq(expected_sorted)
        expect(quick_return).to equal(quick_input)
      end
    end

    # --- 随机数据压力一点的“性质测试”风格 ---

    context 'when sorting random arrays (property-style test)' do
      it 'produces the same result as Array#sort on random data for all algorithms' do
        rng = Random.new(12345)

        # 跑多轮随机测试（数量可以按自己项目的测试时间调整）
        20.times do
          size = rng.rand(0..200) # 数组长度 0~200
          unsorted = Array.new(size) { rng.rand(-10_000..10_000) }
          expected_sorted = unsorted.sort

          # bubble_sort!
          bubble_input  = unsorted.dup
          bubble_return = sorting_helper.bubble_sort!(bubble_input)
          expect(bubble_input).to  eq(expected_sorted)
          expect(bubble_return).to equal(bubble_input)

          # merge_sort
          merge_input  = unsorted.dup
          merge_return = sorting_helper.merge_sort(merge_input)
          expect(merge_return).to eq(expected_sorted)
          expect(merge_input).to  eq(unsorted)

          # quick_sort!
          quick_input  = unsorted.dup
          quick_return = sorting_helper.quick_sort!(quick_input, 0, quick_input.length - 1)
          expect(quick_input).to  eq(expected_sorted)
          expect(quick_return).to equal(quick_input)
        end
      end
    end
  end
end