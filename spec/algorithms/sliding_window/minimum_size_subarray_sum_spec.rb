# frozen_string_literal: true
require "spec_helper"

RSpec.describe SlidingWindow::MinimumSizeSubarraySum do
  let(:solver) { described_class.new }

  describe "#min_sub_array_len" do
    context "invalid input" do
      it "raises error for invalid target" do
        expect { solver.min_sub_array_len(nil, [1, 2, 3]) }.to raise_error(ArgumentError)
        expect { solver.min_sub_array_len(0, [1, 2, 3]) }.to raise_error(ArgumentError)
        expect { solver.min_sub_array_len(-1, [1, 2, 3]) }.to raise_error(ArgumentError)
      end

      it "raises error for non-array nums" do
        expect { solver.min_sub_array_len(7, nil) }.to raise_error(ArgumentError)
        expect { solver.min_sub_array_len(7, "123") }.to raise_error(ArgumentError)
      end

      it "raises error when nums contains non-positive or non-integer values" do
        expect { solver.min_sub_array_len(7, [1, 2, 0]) }.to raise_error(ArgumentError)
        expect { solver.min_sub_array_len(7, [1, -2, 3]) }.to raise_error(ArgumentError)
        expect { solver.min_sub_array_len(7, [1, 2.5, 3]) }.to raise_error(ArgumentError)
      end
    end

    context "edge cases" do
      it "returns 0 for empty array" do
        expect(solver.min_sub_array_len(7, [])).to eq(0)
      end

      it "returns 1 when a single element meets target" do
        expect(solver.min_sub_array_len(4, [4])).to eq(1)
      end

      it "returns 0 when no subarray can meet target" do
        expect(solver.min_sub_array_len(100, [1, 2, 3, 4])).to eq(0)
      end
    end

    context "leetcode examples" do
      it "handles example 1" do
        expect(solver.min_sub_array_len(7, [2, 3, 1, 2, 4, 3])).to eq(2)
      end

      it "handles example 2" do
        expect(solver.min_sub_array_len(4, [1, 4, 4])).to eq(1)
      end

      it "handles example 3" do
        expect(solver.min_sub_array_len(11, [1, 1, 1, 1, 1, 1, 1, 1])).to eq(0)
      end
    end

    context "general cases" do
      it "handles when the whole array is needed" do
        expect(solver.min_sub_array_len(15, [1, 2, 3, 4, 5])).to eq(5)
      end

      it "handles when answer is in the middle" do
        expect(solver.min_sub_array_len(8, [1, 2, 3, 4, 5])).to eq(2)
      end

      it "handles repeated values" do
        expect(solver.min_sub_array_len(6, [1, 1, 1, 1, 1, 1])).to eq(6)
      end
    end
  end
end