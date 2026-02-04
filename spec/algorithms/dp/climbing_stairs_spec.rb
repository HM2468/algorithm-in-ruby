# spec/algorithms/dp/climbing_stairs_spec.rb
require "spec_helper"

RSpec.describe DP::ClimbingStairs do
  describe "#climbing_stairs implementations" do
    let(:solver) { described_class.new }

    shared_examples "climbing stairs solver" do |method_name|
      context "when n is invalid" do
        it "raises ArgumentError for nil" do
          expect { solver.public_send(method_name, nil) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for 0" do
          expect { solver.public_send(method_name, 0) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for negative numbers" do
          expect { solver.public_send(method_name, -1) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for non-integers" do
          expect { solver.public_send(method_name, 1.5) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, "5") }.to raise_error(ArgumentError)
        end
      end

      context "when n is within valid range" do
        it "returns 1 when n = 1" do
          expect(solver.public_send(method_name, 1)).to eq(1)
        end

        it "returns 2 when n = 2" do
          expect(solver.public_send(method_name, 2)).to eq(2)
        end

        it "returns correct results for small n" do
          expect(solver.public_send(method_name, 3)).to eq(3)
          expect(solver.public_send(method_name, 4)).to eq(5)
          expect(solver.public_send(method_name, 5)).to eq(8)
        end

        it "returns correct results for larger n" do
          expect(solver.public_send(method_name, 10)).to eq(89)
          expect(solver.public_send(method_name, 20)).to eq(10_946)
        end
      end
    end

    describe "#memoization_climb" do
      it_behaves_like "climbing stairs solver", :memoization_climb
    end

    describe "#tabulation_climb_1" do
      it_behaves_like "climbing stairs solver", :tabulation_climb_1
    end

    describe "#tabulation_climb_2" do
      it_behaves_like "climbing stairs solver", :tabulation_climb_2
    end

    context "when comparing all implementations" do
      it "returns the same result for n = 1..15" do
        (1..15).each do |n|
          memo = solver.memoization_climb(n)
          tab1 = solver.tabulation_climb_1(n)
          tab2 = solver.tabulation_climb_2(n)

          expect(memo).to eq(tab1)
          expect(tab1).to eq(tab2)
        end
      end
    end
  end
end