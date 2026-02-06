# frozen_string_literal: true
require "spec_helper"

RSpec.describe DP::LongestIncreasingSubsequence do
  describe "#longest_increasing_subsequence implementations" do
    let(:solver) { described_class.new }

    shared_examples "lis solver" do |method_name|
      context "when input is invalid" do
        it "raises ArgumentError for nil" do
          expect { solver.public_send(method_name, nil) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for non-array" do
          expect { solver.public_send(method_name, "123") }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, 123) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for non-integer elements" do
          expect { solver.public_send(method_name, [1, 2.5, 3]) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, [1, "2", 3]) }.to raise_error(ArgumentError)
        end
      end

      context "when input is valid" do
        it "returns 0 for empty array" do
          expect(solver.public_send(method_name, [])).to eq(0)
        end

        it "returns 1 for single element" do
          expect(solver.public_send(method_name, [7])).to eq(1)
        end

        it "matches LeetCode examples" do
          expect(solver.public_send(method_name, [10, 9, 2, 5, 3, 7, 101, 18])).to eq(4)
          expect(solver.public_send(method_name, [0, 1, 0, 3, 2, 3])).to eq(4)
          expect(solver.public_send(method_name, [7, 7, 7, 7, 7, 7, 7])).to eq(1)
        end

        it "handles strictly decreasing array" do
          expect(solver.public_send(method_name, [5, 4, 3, 2, 1])).to eq(1)
        end

        it "handles negatives and mixed values" do
          expect(solver.public_send(method_name, [-1, 3, 4, 5, 2, 2, 2, 2])).to eq(4) # -1,3,4,5
          expect(solver.public_send(method_name, [-2, -1, -3, -4, 0])).to eq(3)        # -2,-1,0
        end

        it "handles typical cases" do
          expect(solver.public_send(method_name, [1, 3, 6, 7, 9, 4, 10, 5, 6])).to eq(6)
          expect(solver.public_send(method_name, [2, 1, 5, 3, 6, 4, 8, 7, 9])).to eq(5)
        end
      end
    end

    describe "#memoization" do
      it_behaves_like "lis solver", :memoization
    end

    describe "#tabulation" do
      it_behaves_like "lis solver", :tabulation
    end

    describe "#patience" do
      it_behaves_like "lis solver", :patience
    end

    context "when comparing all implementations" do
      it "returns the same result across implementations" do
        test_cases = [
          [],
          [7],
          [10, 9, 2, 5, 3, 7, 101, 18],
          [0, 1, 0, 3, 2, 3],
          [7, 7, 7, 7],
          [5, 4, 3, 2, 1],
          [-1, 3, 4, 5, 2, 2, 2, 2],
          [1, 3, 6, 7, 9, 4, 10, 5, 6],
          [2, 1, 5, 3, 6, 4, 8, 7, 9]
        ]

        test_cases.each do |nums|
          memo = solver.memoization(nums)
          tab  = solver.tabulation(nums)
          pat  = solver.patience(nums)

          expect(memo).to eq(tab)
          expect(tab).to eq(pat)
        end
      end
    end
  end
end