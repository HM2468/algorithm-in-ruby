# spec/algorithms/dp/longest_common_subsequence_spec.rb
require "spec_helper"

RSpec.describe DP::LongestCommonSubsequence do
  describe "#longest_common_subsequence implementations" do
    let(:solver) { described_class.new }

    shared_examples "lcs solver" do |method_name|
      context "when inputs are invalid" do
        it "raises ArgumentError for nil" do
          expect { solver.public_send(method_name, nil, "abc") }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, "abc", nil) }.to raise_error(ArgumentError)
        end

        it "raises ArgumentError for non-strings" do
          expect { solver.public_send(method_name, 123, "abc") }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, "abc", 123) }.to raise_error(ArgumentError)
          expect { solver.public_send(method_name, [:a], "abc") }.to raise_error(ArgumentError)
        end
      end

      context "when inputs are valid" do
        it "returns 0 if either string is empty" do
          expect(solver.public_send(method_name, "", "")).to eq(0)
          expect(solver.public_send(method_name, "abc", "")).to eq(0)
          expect(solver.public_send(method_name, "", "abc")).to eq(0)
        end

        it "matches LeetCode examples" do
          expect(solver.public_send(method_name, "abcde", "ace")).to eq(3)
          expect(solver.public_send(method_name, "abc", "abc")).to eq(3)
          expect(solver.public_send(method_name, "abc", "def")).to eq(0)
        end

        it "handles repeated characters" do
          expect(solver.public_send(method_name, "aaaa", "aa")).to eq(2)
          expect(solver.public_send(method_name, "aab", "azab")).to eq(3) # "aab"
        end

        it "handles typical cases" do
          expect(solver.public_send(method_name, "bl", "yby")).to eq(1) # "b"
          expect(solver.public_send(method_name, "ezupkr", "ubmrapg")).to eq(2) # "up"
          expect(solver.public_send(method_name, "XMJYAUZ", "MZJAWXU")).to eq(4) # classic: "MJAU"
        end
      end
    end

    describe "#memoization" do
      it_behaves_like "lcs solver", :memoization
    end

    describe "#tabulation" do
      it_behaves_like "lcs solver", :tabulation
    end

    describe "#tabulation_1d" do
      it_behaves_like "lcs solver", :tabulation_1d
    end

    context "when comparing all implementations" do
      it "returns the same result across implementations for random-ish cases" do
        test_cases = [
          ["abcde", "ace"],
          ["abc", "abc"],
          ["abc", "def"],
          ["aaaa", "aa"],
          ["aab", "azab"],
          ["ezupkr", "ubmrapg"],
          ["XMJYAUZ", "MZJAWXU"],
          ["longestcommonsubsequence", "stonecoldsequence"],
          ["ruby", "rails"],
          ["abcdefg", "bdfh"]
        ]

        test_cases.each do |a, b|
          memo = solver.memoization(a, b)
          tab  = solver.tabulation(a, b)
          one  = solver.tabulation_1d(a, b)

          expect(memo).to eq(tab)
          expect(tab).to eq(one)
        end
      end
    end
  end
end