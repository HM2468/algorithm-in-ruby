# frozen_string_literal: true
require "spec_helper"

RSpec.describe SlidingWindow::LongestSubstring do
  let(:solver) { described_class.new }

  describe "#length_of_longest_substring" do
    context "invalid input" do
      it "raises error for non-string" do
        expect { solver.length_of_longest_substring(nil) }.to raise_error(ArgumentError)
        expect { solver.length_of_longest_substring(123) }.to raise_error(ArgumentError)
      end
    end

    context "edge cases" do
      it "returns 0 for empty string" do
        expect(solver.length_of_longest_substring("")).to eq(0)
      end

      it "handles single character" do
        expect(solver.length_of_longest_substring("a")).to eq(1)
      end
    end

    context "leetcode examples" do
      it "handles example 1" do
        expect(solver.length_of_longest_substring("abcabcbb")).to eq(3)
      end

      it "handles example 2" do
        expect(solver.length_of_longest_substring("bbbbb")).to eq(1)
      end

      it "handles example 3" do
        expect(solver.length_of_longest_substring("pwwkew")).to eq(3)
      end
    end

    context "general cases" do
      it "handles mixed characters" do
        expect(solver.length_of_longest_substring("dvdf")).to eq(3)
        expect(solver.length_of_longest_substring("abba")).to eq(2)
      end

      it "handles all unique characters" do
        expect(solver.length_of_longest_substring("abcdef")).to eq(6)
      end

      it "handles repeated patterns" do
        expect(solver.length_of_longest_substring("tmmzuxt")).to eq(5)
      end
    end
  end
end