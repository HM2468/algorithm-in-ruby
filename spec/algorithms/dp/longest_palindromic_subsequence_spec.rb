require "spec_helper"

RSpec.describe DP::LongestPalindromicSubsequence do
  describe "#longest_palindromic_subsequence implementations" do
    let(:solver) { described_class.new }

    shared_examples "lps solver" do |method_name|
      context "when input is invalid" do
        it "raises ArgumentError for nil" do
          expect { solver.public_send(method_name, nil) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for non-string" do
          expect { solver.public_send(method_name, 123) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, [:a]) }.to raise_error(ArgumentError)
        end
      end

      context "when input is valid" do
        it "returns 0 for empty string" do
          expect(solver.public_send(method_name, "")).to eq(0)
        end

        it "returns 1 for single character" do
          expect(solver.public_send(method_name, "a")).to eq(1)
        end

        it "matches LeetCode examples" do
          expect(solver.public_send(method_name, "bbbab")).to eq(4) # "bbbb"
          expect(solver.public_send(method_name, "cbbd")).to eq(2)  # "bb"
        end

        it "handles already palindromic strings" do
          expect(solver.public_send(method_name, "racecar")).to eq(7)
          expect(solver.public_send(method_name, "aaaaa")).to eq(5)
        end

        it "handles general cases" do
          expect(solver.public_send(method_name, "agbdba")).to eq(5) # "abdba"
          expect(solver.public_send(method_name, "abcda")).to eq(3)  # "aca"
          expect(solver.public_send(method_name, "character")).to eq(5) # "carac"
        end
      end
    end

    describe "#memoization" do
      it_behaves_like "lps solver", :memoization
    end

    describe "#tabulation" do
      it_behaves_like "lps solver", :tabulation
    end

    describe "#tabulation_1d" do
      it_behaves_like "lps solver", :tabulation_1d
    end

    context "when comparing all implementations" do
      it "returns the same result across implementations" do
        test_cases = [
          "",
          "a",
          "bbbab",
          "cbbd",
          "racecar",
          "character",
          "abcdef",
          "aaaaaa",
          "agbdba",
          "abcda"
        ]

        test_cases.each do |s|
          memo = solver.memoization(s)
          tab  = solver.tabulation(s)
          one  = solver.tabulation_1d(s)

          expect(memo).to eq(tab)
          expect(tab).to eq(one)
        end
      end
    end
  end
end