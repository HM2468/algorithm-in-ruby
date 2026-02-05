# spec/algorithms/dp/unique_paths_ii_spec.rb
require "spec_helper"

RSpec.describe DP::UniquePathsII do
  describe "#unique_paths_ii implementations" do
    let(:solver) { described_class.new }

    shared_examples "unique paths ii solver" do |method_name|
      context "when obstacle_grid is invalid" do
        it "raises ArgumentError for nil" do
          expect { solver.public_send(method_name, nil) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for non-array" do
          expect { solver.public_send(method_name, "[]") }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, 123) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for empty grid" do
          expect { solver.public_send(method_name, []) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for non-rectangular grid" do
          expect { solver.public_send(method_name, [[0, 0], [0]]) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for non-array rows" do
          expect { solver.public_send(method_name, [0, 1]) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for invalid cell values" do
          expect { solver.public_send(method_name, [[0, 2], [0, 0]]) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, [[0, -1], [0, 0]]) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, [[0, "1"], [0, 0]]) }.to raise_error(ArgumentError)
        end
      end

      context "when obstacle_grid is valid" do
        it "returns 0 if start is blocked" do
          grid = [[1]]
          expect(solver.public_send(method_name, grid)).to eq(0)
        end

        it "returns 1 for a 1x1 free grid" do
          grid = [[0]]
          expect(solver.public_send(method_name, grid)).to eq(1)
        end

        it "returns 0 if finish is blocked" do
          grid = [
            [0, 0],
            [0, 1]
          ]
          expect(solver.public_send(method_name, grid)).to eq(0)
        end

        it "matches LeetCode example 1" do
          grid = [
            [0, 0, 0],
            [0, 1, 0],
            [0, 0, 0]
          ]
          expect(solver.public_send(method_name, grid)).to eq(2)
        end

        it "matches LeetCode example 2" do
          grid = [
            [0, 1],
            [0, 0]
          ]
          expect(solver.public_send(method_name, grid)).to eq(1)
        end

        it "handles a row with an obstacle blocking propagation" do
          grid = [[0, 0, 1, 0, 0]]
          expect(solver.public_send(method_name, grid)).to eq(0)
        end

        it "handles a column with an obstacle blocking propagation" do
          grid = [
            [0],
            [0],
            [1],
            [0]
          ]
          expect(solver.public_send(method_name, grid)).to eq(0)
        end

        it "handles a grid with no obstacles (should match Unique Paths)" do
          grid = Array.new(3) { Array.new(7, 0) }
          expect(solver.public_send(method_name, grid)).to eq(28)
        end
      end
    end

    describe "#memoization_unique_paths_with_obstacles" do
      it_behaves_like "unique paths ii solver", :memoization_unique_paths_with_obstacles
    end

    describe "#tabulation_unique_paths_with_obstacles" do
      it_behaves_like "unique paths ii solver", :tabulation_unique_paths_with_obstacles
    end

    describe "#tabulation_unique_paths_with_obstacles_1d" do
      it_behaves_like "unique paths ii solver", :tabulation_unique_paths_with_obstacles_1d
    end

    context "when comparing all implementations" do
      it "returns the same result for a variety of grids" do
        test_grids = [
          [[0]],
          [[1]],
          [
            [0, 0],
            [0, 0]
          ],
          [
            [0, 1],
            [0, 0]
          ],
          [
            [0, 0, 0],
            [0, 1, 0],
            [0, 0, 0]
          ],
          [
            [0, 0, 1],
            [0, 0, 0]
          ],
          [
            [0, 0, 0, 0],
            [1, 0, 1, 0],
            [0, 0, 0, 0]
          ]
        ]

        test_grids.each do |grid|
          memo = solver.memoization_unique_paths_with_obstacles(grid)
          tab2 = solver.tabulation_unique_paths_with_obstacles(grid)
          tab1 = solver.tabulation_unique_paths_with_obstacles_1d(grid)

          expect(memo).to eq(tab2)
          expect(tab2).to eq(tab1)
        end
      end
    end
  end
end