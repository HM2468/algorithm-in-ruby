# spec/algorithms/dp/min_cost_climbing_stairs_spec.rb
require "spec_helper"

RSpec.describe DP::MinCostClimbingStairs do
  describe "#min_cost_climbing_stairs implementations" do
    let(:solver) { described_class.new }

    shared_examples "min cost climbing stairs solver" do |method_name|
      context "when cost is invalid" do
        it "raises ArgumentError for nil" do
          expect { solver.public_send(method_name, nil) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for non-array" do
          expect { solver.public_send(method_name, "cost") }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, 123) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError when cost contains non-numeric values" do
          expect { solver.public_send(method_name, [1, "2", 3]) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError when cost contains negative numbers" do
          expect { solver.public_send(method_name, [1, -2, 3]) }.to raise_error(ArgumentError)
        end
      end

      context "when cost is valid" do
        it "returns 0 for empty array" do
          expect(solver.public_send(method_name, [])).to eq(0)
        end

        it "returns cost[0] for single element array" do
          expect(solver.public_send(method_name, [7])).to eq(7)
        end

        it "returns correct results for small inputs" do
          expect(solver.public_send(method_name, [10, 15, 20])).to eq(15)
          expect(solver.public_send(method_name, [1, 100, 1, 1, 1, 100, 1, 1, 100, 1])).to eq(6)
        end

        it "returns correct results when there are zeros" do
          expect(solver.public_send(method_name, [0, 0, 0, 0])).to eq(0)
          expect(solver.public_send(method_name, [0, 1, 2, 0])).to eq(1)
        end

        it "returns correct results for larger inputs" do
          cost = Array.new(30, 1) # all ones
          # minimal cost = floor(n/2) because you can start at 1 and step by 2
          expect(solver.public_send(method_name, cost)).to eq(15)
        end
      end
    end

    describe "#memoization_min_cost" do
      it_behaves_like "min cost climbing stairs solver", :memoization_min_cost
    end

    describe "#tabulation_min_cost_1" do
      it_behaves_like "min cost climbing stairs solver", :tabulation_min_cost_1
    end

    describe "#tabulation_min_cost_2" do
      it_behaves_like "min cost climbing stairs solver", :tabulation_min_cost_2
    end

    context "when comparing all implementations" do
      it "returns the same result for various cost arrays" do
        samples = [
          [],
          [5],
          [10, 15],
          [10, 15, 20],
          [1, 100, 1, 1, 1, 100, 1, 1, 100, 1],
          [0, 1, 2, 0],
          Array.new(20, 2),
          (1..15).to_a
        ]

        samples.each do |cost|
          memo = solver.memoization_min_cost(cost)
          tab1 = solver.tabulation_min_cost_1(cost)
          tab2 = solver.tabulation_min_cost_2(cost)

          expect(memo).to eq(tab1)
          expect(tab1).to eq(tab2)
        end
      end
    end
  end
end