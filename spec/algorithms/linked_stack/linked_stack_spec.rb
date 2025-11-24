# spec/algorithms/linked_stack_spec.rb
require 'spec_helper'

RSpec.describe Algorithms::LinkedStack::Stack do
  subject(:stack) { described_class.new }

  let(:node) { Algorithms::LinkedStack::Node }

  describe 'initial state' do
    it 'can be instantiated without error' do
      expect { stack }.not_to raise_error
    end

    it 'has no elements initially (pop returns nil)' do
      expect(stack.pop).to be_nil
      expect(stack.pop).to be_nil
    end

    it 'has internal @top set to nil' do
      top = stack.instance_variable_get(:@top)
      expect(top).to be_nil
    end

    it 'is empty when initialized' do
      expect(stack.empty?).to be true
    end
  end

  describe '#push' do
    it 'pushes a single element and allows it to be popped back' do
      stack.push(1)
      expect(stack.pop).to eq(1)
      expect(stack.pop).to be_nil
    end

    it 'supports different Ruby object types as values' do
      stack.push(123)
      stack.push('hello')
      stack.push({ a: 1 })
      stack.push([1, 2, 3])

      expect(stack.pop).to eq([1, 2, 3])
      expect(stack.pop).to eq({ a: 1 })
      expect(stack.pop).to eq('hello')
      expect(stack.pop).to eq(123)
      expect(stack.pop).to be_nil
    end

    it 'chains nodes via @top.next in correct order' do
      stack.push(1)
      stack.push(2)
      stack.push(3)

      top = stack.instance_variable_get(:@top)
      collected = []

      while top
        collected << top.val
        top = top.next
      end

      # 注意：从 top 开始，所以顺序是 [3, 2, 1]
      expect(collected).to eq([3, 2, 1])
    end
  end

  describe '#pop' do
    context 'when stack is empty' do
      it 'returns nil' do
        expect(stack.pop).to be_nil
      end

      it 'does not change internal state if called multiple times' do
        3.times { stack.pop }
        top = stack.instance_variable_get(:@top)
        expect(top).to be_nil
      end

      it 'keeps empty? returning true' do
        3.times { stack.pop }
        expect(stack.empty?).to be true
      end
    end

    context 'when stack has one element' do
      before { stack.push(:only_one) }

      it 'returns that element' do
        expect(stack.pop).to eq(:only_one)
      end

      it 'makes stack behave like empty afterwards' do
        stack.pop
        expect(stack.pop).to be_nil
        top = stack.instance_variable_get(:@top)
        expect(top).to be_nil
        expect(stack.empty?).to be true
      end
    end

    context 'when stack has multiple elements' do
      before do
        stack.push(1)
        stack.push(2)
        stack.push(3)
      end

      it 'returns elements in LIFO order (last in, first out)' do
        expect(stack.pop).to eq(3)
        expect(stack.pop).to eq(2)
        expect(stack.pop).to eq(1)
        expect(stack.pop).to be_nil
      end

      it 'updates @top correctly after each pop' do
        # 初始 top 应该是 3
        top = stack.instance_variable_get(:@top)
        expect(top.val).to eq(3)

        stack.pop # 弹出 3

        top = stack.instance_variable_get(:@top)
        expect(top.val).to eq(2)
        expect(top.next.val).to eq(1)

        stack.pop # 弹出 2

        top = stack.instance_variable_get(:@top)
        expect(top.val).to eq(1)
        expect(top.next).to be_nil

        stack.pop # 弹出 1

        top = stack.instance_variable_get(:@top)
        expect(top).to be_nil
      end
    end
  end

  describe '#empty?' do
    it 'returns true for a newly created stack' do
      expect(stack.empty?).to be true
    end

    it 'returns false after pushing an element' do
      stack.push(42)
      expect(stack.empty?).to be false
    end

    it 'returns true again after all elements are popped' do
      stack.push(1)
      stack.push(2)
      expect(stack.empty?).to be false

      stack.pop
      expect(stack.empty?).to be false

      stack.pop
      expect(stack.empty?).to be true
    end

    it 'works correctly under interleaved push/pop' do
      expect(stack.empty?).to be true

      stack.push(1)
      expect(stack.empty?).to be false

      stack.pop
      expect(stack.empty?).to be true

      stack.push(2)
      stack.push(3)
      expect(stack.empty?).to be false

      stack.pop
      stack.pop
      expect(stack.empty?).to be true
    end
  end

  describe 'interleaved push and pop' do
    it 'handles push/pop in mixed order correctly' do
      stack.push(1)
      stack.push(2)
      expect(stack.pop).to eq(2)

      stack.push(3)
      stack.push(4)
      expect(stack.pop).to eq(4)
      expect(stack.pop).to eq(3)
      expect(stack.pop).to eq(1)
      expect(stack.pop).to be_nil
      expect(stack.empty?).to be true
    end

    it 'supports multiple cycles of filling and draining the stack' do
      3.times do |round|
        values = (1..5).map { |i| "#{round}-#{i}" }

        values.each { |v| stack.push(v) }

        popped = []
        5.times { popped << stack.pop }

        # 栈是 LIFO，所以弹出顺序是逆序
        expect(popped).to eq(values.reverse)

        # 每一轮结束后，栈应为空
        expect(stack.pop).to be_nil
        expect(stack.empty?).to be true
      end
    end
  end

  describe 'basic stress test' do
    it 'can handle many push/pop operations without breaking linkage' do
      n = 1000

      n.times { |i| stack.push(i) }
      expect(stack.empty?).to be false

      # 弹出前一半
      (n / 2).times do |i|
        expect(stack.pop).to eq(n - 1 - i)
      end

      # 再 push 一些新元素
      100.times { |i| stack.push("x#{i}") }

      # 把所有元素弹干，不要求精确校验所有值，只要不崩溃
      until stack.pop.nil?
        # no-op
      end

      # 最后 top 应该回到 nil，empty? 应为 true
      top = stack.instance_variable_get(:@top)
      expect(top).to be_nil
      expect(stack.empty?).to be true
    end
  end

  describe 'Node struct' do
    it 'is defined as Algorithms::LinkedStack::Node' do
      expect(node).to be_a(Class)
      expect(node.ancestors).to include(Struct)
    end

    it 'stores val and next correctly' do
      node1 = node.new(1)
      node2 = node.new(2, node1)

      expect(node1.val).to eq(1)
      expect(node1.next).to be_nil

      expect(node2.val).to eq(2)
      expect(node2.next).to eq(node1)
    end
  end
end