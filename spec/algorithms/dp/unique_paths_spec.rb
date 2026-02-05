# spec/algorithms/dp/unique_paths_spec.rb
require "spec_helper"

RSpec.describe DP::UniquePaths do
  describe "#unique_paths implementations" do
    let(:solver) { described_class.new }

    shared_examples "unique paths solver" do |method_name|
      context "when m or n is invalid" do
        it "raises ArgumentError for nil" do
          expect { solver.public_send(method_name, nil, 1) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, 1, nil) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for 0" do
          expect { solver.public_send(method_name, 0, 1) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, 1, 0) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for negative numbers" do
          expect { solver.public_send(method_name, -1, 1) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, 1, -1) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for non-integers" do
          expect { solver.public_send(method_name, 1.5, 2) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, 2, 3.2) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, "3", 2) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, 3, "2") }.to raise_error(ArgumentError)
        end
      end

      context "when m and n are within valid range" do
        it "returns 1 when m = 1 or n = 1" do
          expect(solver.public_send(method_name, 1, 1)).to eq(1)
          expect(solver.public_send(method_name, 1, 5)).to eq(1)
          expect(solver.public_send(method_name, 5, 1)).to eq(1)
        end

        it "returns correct results for small grids" do
          expect(solver.public_send(method_name, 2, 2)).to eq(2)
          expect(solver.public_send(method_name, 2, 3)).to eq(3)
          expect(solver.public_send(method_name, 3, 2)).to eq(3)
          expect(solver.public_send(method_name, 3, 3)).to eq(6)
        end

        it "returns correct results for medium grids" do
          expect(solver.public_send(method_name, 3, 7)).to eq(28)  # classic example
          expect(solver.public_send(method_name, 7, 3)).to eq(28)  # symmetry
          expect(solver.public_send(method_name, 10, 10)).to eq(48_620)
        end

        it "is symmetric: unique_paths(m, n) == unique_paths(n, m)" do
          (1..10).each do |m|
            (1..10).each do |n|
              a = solver.public_send(method_name, m, n)
              b = solver.public_send(method_name, n, m)
              expect(a).to eq(b)
            end
          end
        end
      end
    end

    describe "#memoization" do
      it_behaves_like "unique paths solver", :memoization
    end

    describe "#tabulation" do
      it_behaves_like "unique paths solver", :tabulation
    end

    describe "#tabulation_1d" do
      it_behaves_like "unique paths solver", :tabulation_1d
    end

    context "when comparing all implementations" do
      it "returns the same result for m,n in 1..12" do
        (1..12).each do |m|
          (1..12).each do |n|
            memo = solver.memoization(m, n)
            tab  = solver.tabulation(m, n)

            expect(memo).to eq(tab)
          end
        end
      end
    end
  end
end