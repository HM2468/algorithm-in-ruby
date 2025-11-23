# spec/algorithms/linked_stack/daily_temperatures_spec.rb
require 'spec_helper'

RSpec.describe Algorithms::LinkedStack do
  include Algorithms::LinkedStack

  describe '#daily_temperatures' do
    subject(:result) { daily_temperatures(input) }

    context 'when using the example from the problem statement' do
      let(:input)  { [73, 74, 75, 71, 69, 72, 76, 73] }
      let(:output) { [1, 1, 4, 2, 1, 1, 0, 0] }

      it 'returns the correct waiting days array' do
        expect(result).to eq(output)
      end
    end

    context 'when the input is an empty array' do
      let(:input) { [] }

      it 'returns an empty array' do
        expect(result).to eq([])
      end
    end

    context 'when the input has only one temperature' do
      let(:input) { [73] }

      it 'returns [0] because there is no future warmer day' do
        expect(result).to eq([0])
      end
    end

    context 'when the temperatures are strictly increasing' do
      # 每一天都会在下一天变暖
      let(:input)  { [10, 20, 30, 40] }
      let(:output) { [1, 1, 1, 0] }

      it 'each day waits exactly 1 day except the last one' do
        expect(result).to eq(output)
      end
    end

    context 'when the temperatures are strictly decreasing' do
      # 没有未来更暖的一天，全是 0
      let(:input)  { [40, 30, 20, 10] }
      let(:output) { [0, 0, 0, 0] }

      it 'returns all zeros' do
        expect(result).to eq(output)
      end
    end

    context 'when all temperatures are the same' do
      # 都相同，也没有未来更暖的一天
      let(:input)  { [30, 30, 30, 30] }
      let(:output) { [0, 0, 0, 0] }

      it 'returns all zeros' do
        expect(result).to eq(output)
      end
    end

    context 'when temperatures fluctuate up and down' do
      # 手动算一下：
      # index:        0   1   2   3   4   5
      # temps:       30, 60, 50, 40, 45, 70
      # result:
      #   0 -> 最近更暖的是 1 (60)，等待 1 天
      #   1 -> 最近更暖的是 5 (70)，等待 4 天
      #   2 -> 最近更暖的是 5 (70)，等待 3 天
      #   3 -> 最近更暖的是 4 (45)，等待 1 天
      #   4 -> 最近更暖的是 5 (70)，等待 1 天
      #   5 -> 之后没有更暖，0
      let(:input)  { [30, 60, 50, 40, 45, 70] }
      let(:output) { [1, 4, 3, 1, 1, 0] }

      it 'handles mixed up and down temperatures correctly' do
        expect(result).to eq(output)
      end
    end

    context 'when input contains negative or zero temperatures' do
      # 即使是负数和 0，只要遵守“大于”比较就可以。
      # index:        0   1   2   3
      # temps:      -5,  0, -3,  2
      # result:
      #   0 -> 最近更暖的是 1 (0)，等待 1 天
      #   1 -> 最近更暖的是 3 (2)，等待 2 天
      #   2 -> 最近更暖的是 3 (2)，等待 1 天
      #   3 -> 没有更暖，0
      let(:input)  { [-5, 0, -3, 2] }
      let(:output) { [1, 2, 1, 0] }

      it 'still works with non-positive temperatures' do
        expect(result).to eq(output)
      end
    end

    context 'when checking that the original input is not mutated' do
      let(:input) { [73, 74, 75] }

      it 'does not change the input array' do
        copy = input.dup
        daily_temperatures(input)
        expect(input).to eq(copy)
      end
    end

    context 'stack behavior indirectly (sanity check)' do
      let(:input)  { [73, 74, 75, 71, 69, 72, 76, 73] }
      let(:output) { [1, 1, 4, 2, 1, 1, 0, 0] }

      it 'ensures each day that has a warmer future day gets a positive number' do
        expect(result[0..5]).to all(be > 0)
      end

      it 'ensures days without warmer future day get 0' do
        expect(result[6..7]).to all(eq(0))
      end

      it 'matches the fully expected output (sanity + exact match)' do
        expect(result).to eq(output)
      end
    end
  end
end