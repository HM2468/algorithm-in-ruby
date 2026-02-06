# frozen_string_literal: true
require "spec_helper"

RSpec.describe DP::LongestPalindromicSubstring do
  describe "#longest_palindromic_substring implementations" do
    let(:solver) { described_class.new }

    def palindrome?(str)
      str == str.reverse
    end

    shared_examples "lpsubstr solver" do |method_name|
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
        it "returns empty string for empty input" do
          expect(solver.public_send(method_name, "")).to eq("")
        end

        it "handles single character" do
          expect(solver.public_send(method_name, "a")).to eq("a")
        end

        it "matches LeetCode examples (allow multiple correct answers)" do
          ans = solver.public_send(method_name, "babad")
          expect(["bab", "aba"]).to include(ans)

          expect(solver.public_send(method_name, "cbbd")).to eq("bb")
        end

        it "handles all same characters" do
          expect(solver.public_send(method_name, "aaaa")).to eq("aaaa")
        end

        it "handles no repeated palindrome longer than 1" do
          out = solver.public_send(method_name, "abcd")
          expect(out.length).to eq(1)
          expect("abcd").to include(out)
        end

        it "returns a palindrome substring of maximal length" do
          s = "forgeeksskeegfor"
          out = solver.public_send(method_name, s)
          expect(palindrome?(out)).to eq(true)
          expect(s).to include(out)
          expect(out.length).to eq(10) # "geeksskeeg"
        end
      end
    end

    describe "#memoization" do
      it_behaves_like "lpsubstr solver", :memoization
    end

    describe "#tabulation" do
      it_behaves_like "lpsubstr solver", :tabulation
    end

    describe "#center_expand" do
      it_behaves_like "lpsubstr solver", :center_expand
    end

    context "when comparing all implementations" do
      it "returns same maximum length across implementations" do
        test_cases = [
          "",
          "a",
          "babad",
          "cbbd",
          "aaaa",
          "abcd",
          "forgeeksskeegfor",
          "racecar",
          "banana"
        ]

        test_cases.each do |s|
          a = solver.memoization(s)
          b = solver.tabulation(s)
          c = solver.center_expand(s)

          max_len = [a.length, b.length, c.length].max
          expect(a.length).to eq(max_len)
          expect(b.length).to eq(max_len)
          expect(c.length).to eq(max_len)

          expect(palindrome?(a)).to eq(true) unless a.empty?
          expect(palindrome?(b)).to eq(true) unless b.empty?
          expect(palindrome?(c)).to eq(true) unless c.empty?

          expect(s).to include(a) unless a.empty?
          expect(s).to include(b) unless b.empty?
          expect(s).to include(c) unless c.empty?
        end
      end
    end
  end
end