# frozen_string_literal: true
require "spec_helper"

RSpec.describe SlidingWindow::BrutalForceSubstring do
  let(:solver) { described_class.new }

  describe "#all_substrings" do
    context "invalid input" do
      it "raises error for non-string" do
        expect { solver.all_substrings(nil) }.to raise_error(ArgumentError)
        expect { solver.all_substrings(123) }.to raise_error(ArgumentError)
        expect { solver.all_substrings(["a", "b"]) }.to raise_error(ArgumentError)
      end
    end

    context "edge cases" do
      it "returns empty array for empty string" do
        expect(solver.all_substrings("")).to eq([])
      end

      it "handles single character" do
        expect(solver.all_substrings("a")).to eq(["a"])
      end
    end

    context "general cases" do
      it "returns all substrings for a short string" do
        expect(solver.all_substrings("abc")).to eq(
          ["a", "ab", "abc", "b", "bc", "c"]
        )
      end

      it "handles repeated characters" do
        expect(solver.all_substrings("aaa")).to eq(
          ["a", "aa", "aaa", "a", "aa", "a"]
        )
      end

      it "handles two characters" do
        expect(solver.all_substrings("ab")).to eq(
          ["a", "ab", "b"]
        )
      end
    end

    context "substring count" do
      it "returns n * (n + 1) / 2 substrings" do
        s = "abcd"
        result = solver.all_substrings(s)
        expect(result.length).to eq(s.length * (s.length + 1) / 2)
      end
    end
  end
end