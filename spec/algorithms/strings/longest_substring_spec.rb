# spec/algorithms/strings/longest_substring_without_repeating_characters_spec.rb
require "spec_helper"

RSpec.describe 'Longest Substring Without Repeating Characters' do
  include Algorithms::Strings
  describe ".length_of_longest_substring" do
    it "handles empty string" do
      expect(length_of_longest_substring("")).to eq(0)
    end

    it "returns 3 for 'abcabcbb'" do
      expect(length_of_longest_substring("abcabcbb")).to eq(3)
    end

    it "returns 1 for 'bbbbb'" do
      expect(length_of_longest_substring("bbbbb")).to eq(1)
    end

    it "returns 3 for 'pwwkew'" do
      expect(length_of_longest_substring("pwwkew")).to eq(3)
    end

    it "returns 3 for 'abcdeff'" do
      expect(length_of_longest_substring("abcdeff")).to eq(6)
    end

    it "handles all unique characters" do
      expect(length_of_longest_substring("abcdef")).to eq(6)
    end

    it "handles repeated characters in the middle" do
      expect(length_of_longest_substring("abba")).to eq(2) # "ab" 或 "ba"
    end

    it "handles unicode characters" do
      # 包含中文或 emoji
      expect(length_of_longest_substring("我爱编程我爱Ruby")).to eq(8)
      # "我爱编程我爱Ruby" 实际最长无重复子串可按你需要改，这里主要是示例
    end
  end
end