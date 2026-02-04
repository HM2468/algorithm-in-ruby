# spec/algorithms/dp/house_robber_spec.rb
require "spec_helper"

RSpec.describe DP::HouseRobber do
  describe "#rob implementations" do
    let(:solver) { described_class.new }

    shared_examples "house robber solver" do |method_name|
      context "when nums is invalid" do
        it "raises ArgumentError for nil" do
          expect { solver.public_send(method_name, nil) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for non-array" do
          expect { solver.public_send(method_name, "[]") }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, 123) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, { a: 1 }) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError when array contains non-integers" do
          expect { solver.public_send(method_name, [1, 2.5, 3]) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, [1, "2", 3]) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, [nil]) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError when array contains negative integers" do
          expect { solver.public_send(method_name, [1, -1, 2]) }.to raise_error(ArgumentError)
        end
      end

      context "when nums is within valid range" do
        it "returns 0 for empty array" do
          expect(solver.public_send(method_name, [])).to eq(0)
        end

        it "returns correct results for 1-2 elements" do
          expect(solver.public_send(method_name, [5])).to eq(5)
          expect(solver.public_send(method_name, [2, 1])).to eq(2)
          expect(solver.public_send(method_name, [1, 2])).to eq(2)
          expect(solver.public_send(method_name, [0, 0])).to eq(0)
        end

        it "returns correct results for provided examples" do
          expect(solver.public_send(method_name, [1, 2, 3, 1])).to eq(4)
          expect(solver.public_send(method_name, [2, 7, 9, 3, 1])).to eq(12)
        end

        it "handles zeros and typical cases" do
          expect(solver.public_send(method_name, [0, 0, 0])).to eq(0)
          expect(solver.public_send(method_name, [2, 1, 1, 2])).to eq(4)
          expect(solver.public_send(method_name, [1, 3, 1])).to eq(3)
          expect(solver.public_send(method_name, [4, 1, 1, 9, 1])).to eq(13) # 4 + 9
        end

        it "handles larger arrays" do
          expect(solver.public_send(method_name, [1] * 10)).to eq(5)
          expect(solver.public_send(method_name, [2] * 11)).to eq(12) # pick 6 houses => 6*2
        end
      end
    end

    describe "#rob" do
      it_behaves_like "house robber solver", :rob
    end

    context "when comparing all implementations" do
      # Future-proof: if you add more implementations later, list them here.
      let(:implementations) { [:rob] }

      it "returns the same result for a variety of inputs" do
        test_cases = [
          [],
          [0],
          [1],
          [2, 1],
          [1, 2],
          [1, 2, 3, 1],
          [2, 7, 9, 3, 1],
          [2, 1, 1, 2],
          [4, 1, 1, 9, 1],
          [0, 0, 0, 0],
          [1] * 15,
          [2] * 16,
          [5, 3, 4, 11, 2, 7, 9, 1]
        ]

        test_cases.each do |nums|
          results = implementations.map { |m| solver.public_send(m, nums) }
          expect(results.uniq.size).to eq(1), "Expected all implementations to match for nums=#{nums.inspect}, got #{results.inspect}"
        end
      end
    end
  end
end