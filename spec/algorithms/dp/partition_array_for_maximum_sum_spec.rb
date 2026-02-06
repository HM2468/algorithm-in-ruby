# frozen_string_literal: true
require "spec_helper"

RSpec.describe DP::PartitionArrayForMaximumSum do
  describe "#partition_array_for_maximum_sum implementations" do
    let(:solver) { described_class.new }

    shared_examples "partition dp solver" do |method_name|
      context "when inputs are invalid" do
        it "raises ArgumentError for invalid arr" do
          expect { solver.public_send(method_name, nil, 3) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, "123", 3) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for invalid k" do
          expect { solver.public_send(method_name, [1, 2, 3], 0) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, [1, 2, 3], -1) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, [1, 2, 3], "3") }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for non-integer elements" do
          expect { solver.public_send(method_name, [1, 2.5, 3], 3) }.to raise_error(ArgumentError)
        end
      end

      context "when inputs are valid" do
        it "returns 0 for empty array" do
          expect(solver.public_send(method_name, [], 3)).to eq(0)
        end

        it "handles single element" do
          expect(solver.public_send(method_name, [5], 3)).to eq(5)
        end

        it "matches LeetCode examples" do
          expect(
            solver.public_send(method_name, [1,15,7,9,2,5,10], 3)
          ).to eq(84)

          expect(
            solver.public_send(method_name, [1,4,1,5,7,3,6,1,9,9,3], 4)
          ).to eq(83)
        end

        it "handles k = 1 (no grouping)" do
          expect(
            solver.public_send(method_name, [3,1,2,4], 1)
          ).to eq(3 + 1 + 2 + 4)
        end

        it "handles k >= n (can group whole array)" do
          expect(
            solver.public_send(method_name, [2,2,2], 10)
          ).to eq(2 * 3)
        end

        it "handles typical cases" do
          expect(
            solver.public_send(method_name, [10, 9, 8, 7], 2)
          ).to eq(36)
        end
      end
    end

    describe "#memoization" do
      it_behaves_like "partition dp solver", :memoization
    end

    describe "#tabulation" do
      it_behaves_like "partition dp solver", :tabulation
    end

    context "when comparing all implementations" do
      it "returns the same result across implementations" do
        test_cases = [
          [[1,15,7,9,2,5,10], 3],
          [[1,4,1,5,7,3,6,1,9,9,3], 4],
          [[5], 3],
          [[3,1,2,4], 1],
          [[2,2,2], 10],
          [[10,9,8,7], 2]
        ]

        test_cases.each do |arr, k|
          memo = solver.memoization(arr, k)
          tab  = solver.tabulation(arr, k)

          expect(memo).to eq(tab)
        end
      end
    end
  end
end