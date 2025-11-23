# spec/algorithms/linked_stack/valid_parentheses_spec.rb
require 'spec_helper'

RSpec.describe 'Valid Parentheses' do

  include Algorithms::LinkedStack

  describe 'valid_parentheses?' do
    context 'when string is empty' do
      it 'returns true for empty string' do
        expect(valid_parentheses?('')).to be true
      end
    end

    context 'with simple valid cases' do
      it 'returns true for "()"' do
        expect(valid_parentheses?('()')).to be true
      end

      it 'returns true for "()[]{}"' do
        expect(valid_parentheses?('()[]{}')).to be true
      end

      it 'returns true for "{[]}"' do
        expect(valid_parentheses?('{[]}')).to be true
      end

      it 'returns true for "([])"' do
        expect(valid_parentheses?('([])')).to be true
      end

      it 'returns true for "[({})]"' do
        expect(valid_parentheses?('[({})]')).to be true
      end

      it 'returns true for "[[]]"' do
        expect(valid_parentheses?('[[]]')).to be true
      end

      it 'returns true for "(([]){})"' do
        expect(valid_parentheses?('(([]){})')).to be true
      end
    end

    context 'with simple invalid cases' do
      it 'returns false for "(" (single left parenthesis)' do
        expect(valid_parentheses?('(')).to be false
      end

      it 'returns false for ")" (single right parenthesis)' do
        expect(valid_parentheses?(')')).to be false
      end

      it 'returns false for "(]"' do
        expect(valid_parentheses?('(]')).to be false
      end

      it 'returns false for "([)]"' do
        expect(valid_parentheses?('([)]')).to be false
      end

      it 'returns false for "(((("' do
        expect(valid_parentheses?('((((')).to be false
      end

      it 'returns false for "))))"' do
        expect(valid_parentheses?('))))')).to be false
      end

      it 'returns false for ")(" (wrong order)' do
        expect(valid_parentheses?(')(')).to be false
      end

      it 'returns false for "][" (wrong order square brackets)' do
        expect(valid_parentheses?('][')).to be false
      end
    end

    context 'with longer mixed patterns' do
      it 'returns true for "()()()"' do
        expect(valid_parentheses?('()()()')).to be true
      end

      it 'returns true for "{[()()]()}"' do
        expect(valid_parentheses?('{[()()]()}')).to be true
      end

      it 'returns false when there is an extra left bracket at the end' do
        expect(valid_parentheses?('()()(()')).to be false
      end

      it 'returns false when there is an extra right bracket in the middle' do
        expect(valid_parentheses?('()())()')).to be false
      end
    end

    context 'when there are non-bracket characters' do
      # 根据当前实现：
      # 非括号字符既不会入栈也不会导致 false，相当于“忽略非括号字符”，只关心括号是否匹配。
      it 'ignores letters and returns true if brackets are balanced' do
        expect(valid_parentheses?('a(b)c')).to be true
      end

      it 'ignores digits and returns false if brackets are not balanced' do
        expect(valid_parentheses?('1(2]3')).to be false
      end

      it 'returns true when there are no brackets at all' do
        expect(valid_parentheses?('abc123')).to be true
      end
    end

    context 'edge cases' do
      it 'handles a single type of bracket repeated correctly (e.g., "[][]")' do
        expect(valid_parentheses?('[][]')).to be true
      end

      it 'handles a single type of bracket repeated incorrectly (e.g., "[]][")' do
        expect(valid_parentheses?('[]][')).to be false
      end

      it 'handles deeply nested brackets' do
        s = '(((([[[{{{( )}}}]]]))))'
        expect(valid_parentheses?(s)).to be true
      end

      it 'returns false when only part of nested structure is closed' do
        s = '(((([[[{{{()}}}]])))'
        expect(valid_parentheses?(s)).to be false
      end
    end
  end
end