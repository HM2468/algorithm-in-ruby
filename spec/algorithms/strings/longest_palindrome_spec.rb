# file: spec/algorithms/longest_palindrome_spec.rb

require "spec_helper"

RSpec.describe 'Longest palindromic Substring' do
  include Algorithms::Strings
  # 小工具方法：判断是否回文
  def palindrome?(str)
    str == str.reverse
  end

  it 'returns empty string for nil input' do
    expect(longest_palindrome(nil)).to eq("")
  end

  it 'returns empty string for empty input' do
    expect(longest_palindrome("")).to eq("")
  end

  it 'handles single character string' do
    expect(longest_palindrome("a")).to eq("a")
    expect(longest_palindrome("z")).to eq("z")
  end

  context 'with all identical characters' do
    it 'returns the whole string' do
      expect(longest_palindrome("aaaa")).to eq("aaaa")
      expect(longest_palindrome("bbbbbbbb")).to eq("bbbbbbbb")
    end
  end

  context 'with no repeated characters' do
    it 'returns a single character' do
      result = longest_palindrome("abcde")
      expect(result.length).to eq(1)
      expect("abcde".chars).to include(result)
      expect(palindrome?(result)).to be true
    end
  end

  context 'leetcode example cases' do
    it 'handles "babad"' do
      result = longest_palindrome("babad")
      # LeetCode 官方：可以是 "bab" 或 "aba"
      expect(%w[bab aba]).to include(result)
      expect(palindrome?(result)).to be true
    end

    it 'handles "cbbd"' do
      expect(longest_palindrome("cbbd")).to eq("bb")
    end
  end

  context 'mixed examples' do
    it 'handles even length palindromes in the middle' do
      expect(longest_palindrome("abccba")).to eq("abccba")
      expect(longest_palindrome("xabccbay")).to eq("abccba")
    end

    it 'handles odd length palindromes in the middle' do
      expect(longest_palindrome("racecar")).to eq("racecar")
      expect(longest_palindrome("xracecary")).to eq("racecar")
    end

    it 'handles palindrome at the beginning' do
      expect(longest_palindrome("abbaXYZ")).to eq("abba")
    end

    it 'handles palindrome at the end' do
      expect(longest_palindrome("XYZabba")).to eq("abba")
    end

    it 'handles long string with multiple palindromes' do
      s = "forgeeksskeegfor"
      expect(longest_palindrome(s)).to eq("geeksskeeg")
    end
  end

  context 'edge and stress tests' do
    it 'handles length-2 strings correctly' do
      expect(longest_palindrome("aa")).to eq("aa")
      result = longest_palindrome("ab")
      expect(result.length).to eq(1)
      expect(%w[a b]).to include(result)
      expect(palindrome?(result)).to be true
    end

    it 'handles string where best palindrome is length 2' do
      expect(longest_palindrome("abcdd")).to eq("dd")
    end

    it 'handles long repeating characters efficiently' do
      s = "a" * 1000
      result = longest_palindrome(s)
      expect(result.length).to eq(1000)
      expect(palindrome?(result)).to be true
    end

    it 'handles string with multiple equal-length best palindromes' do
      s = "abacdfgdcaba"
      result = longest_palindrome(s)
      # 这里可能返回 "aba"（前面）或 "aba"（后面），都是长度 3
      expect(result.length).to eq(3)
      expect(palindrome?(result)).to be true
      expect(%w[aba]).to include(result) # 两段其实内容一样
    end
  end
end