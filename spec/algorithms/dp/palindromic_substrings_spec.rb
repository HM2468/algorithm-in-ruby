# frozen_string_literal: true
require "spec_helper"

RSpec.describe DP::PalindromicSubstrings do
  let(:solver) { described_class.new }

  shared_examples "palindromic substrings solver" do |method|
    context "invalid input" do
      it "raises ArgumentError for non-string" do
        expect { solver.public_send(method, nil) }.to raise_error(ArgumentError)
        expect { solver.public_send(method, 123) }.to raise_error(ArgumentError)
      end
    end

    context "valid input" do
      it "handles empty string" do
        expect(solver.public_send(method, "")).to eq(0)
      end

      it "handles single character" do
        expect(solver.public_send(method, "a")).to eq(1)
      end

      it "matches LeetCode examples" do
        expect(solver.public_send(method, "abc")).to eq(3) # a, b, c
        expect(solver.public_send(method, "aaa")).to eq(6) # a,a,a,aa,aa,aaa
      end

      it "handles mixed cases" do
        expect(solver.public_send(method, "abba")).to eq(6)
        # a, b, b, a, bb, abba
      end

      it "handles general cases" do
        expect(solver.public_send(method, "racecar")).to eq(10)
        expect(solver.public_send(method, "abccba")).to eq(9)
      end
    end
  end

  describe "#memoization" do
    it_behaves_like "palindromic substrings solver", :memoization
  end

  describe "#tabulation" do
    it_behaves_like "palindromic substrings solver", :tabulation
  end

  describe "#center_expand" do
    it_behaves_like "palindromic substrings solver", :center_expand
  end

  context "cross-method consistency" do
    it "returns same result across implementations" do
      test_cases = [
        "",
        "a",
        "abc",
        "aaa",
        "abba",
        "racecar",
        "abccba",
        "banana",
        "civic"
      ]

      test_cases.each do |s|
        m = solver.memoization(s)
        t = solver.tabulation(s)
        c = solver.center_expand(s)

        expect(m).to eq(t)
        expect(t).to eq(c)
      end
    end
  end
end