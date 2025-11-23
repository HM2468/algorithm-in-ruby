# spec/algorithms/linked_queue_spec.rb
require 'spec_helper'

RSpec.describe Algorithms::LinkedQueue::Queue do
  let(:queue) { described_class.new }

  describe 'initial state' do
    it 'is empty after initialization' do
      expect(queue.empty?).to be true
    end

    it 'returns nil when dequeue is called on empty queue' do
      expect(queue.dequeue).to be_nil
    end

    it 'remains empty after multiple dequeues on empty queue' do
      3.times { queue.dequeue }
      expect(queue.empty?).to be true
      expect(queue.dequeue).to be_nil
    end
  end

  describe '#enqueue' do
    it 'makes the queue non-empty after first enqueue' do
      queue.enqueue(1)
      expect(queue.empty?).to be false
    end

    it 'accepts different types of values' do
      queue.enqueue(1)
      queue.enqueue('a')
      queue.enqueue({ x: 1 })
      queue.enqueue([1, 2, 3])

      expect(queue.dequeue).to eq(1)
      expect(queue.dequeue).to eq('a')
      expect(queue.dequeue).to eq({ x: 1 })
      expect(queue.dequeue).to eq([1, 2, 3])
      expect(queue.empty?).to be true
    end

    it 'preserves insertion order (FIFO) for multiple enqueues' do
      values = [10, 20, 30, 40, 50]
      values.each { |v| queue.enqueue(v) }

      dequeued = []
      until queue.empty?
        dequeued << queue.dequeue
      end

      expect(dequeued).to eq(values)
    end

    it 'links nodes correctly internally (head -> ... -> tail)' do
      values = [1, 2, 3]
      values.each { |v| queue.enqueue(v) }

      # 通过内部指针检查链表结构
      head = queue.instance_variable_get(:@head)
      collected = []
      while head
        collected << head.val
        head = head.next
      end

      expect(collected).to eq(values)
    end
  end

  describe '#dequeue' do
    context 'when queue has only one element' do
      it 'returns that element and becomes empty' do
        queue.enqueue(42)

        expect(queue.empty?).to be false
        expect(queue.dequeue).to eq(42)
        expect(queue.empty?).to be true
        expect(queue.dequeue).to be_nil
      end
    end

    context 'when queue has multiple elements' do
      before do
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
      end

      it 'returns elements in FIFO order' do
        expect(queue.dequeue).to eq(1)
        expect(queue.dequeue).to eq(2)
        expect(queue.dequeue).to eq(3)
        expect(queue.dequeue).to be_nil
        expect(queue.empty?).to be true
      end

      it 'keeps internal pointers consistent after partial dequeue' do
        # 出队一个元素
        expect(queue.dequeue).to eq(1)

        # 现在队列里应该还有 2, 3
        head = queue.instance_variable_get(:@head)
        tail = queue.instance_variable_get(:@tail)

        expect(head).not_to be_nil
        expect(tail).not_to be_nil
        expect(head.val).to eq(2)
        expect(tail.val).to eq(3)
        expect(head.next).to eq(tail)
        expect(tail.next).to be_nil
      end
    end

    context 'when queue becomes empty after last dequeue' do
      it 'sets both @head and @tail to nil' do
        queue.enqueue('a')
        queue.enqueue('b')

        queue.dequeue  # :a
        queue.dequeue  # :b，使队列变空

        head = queue.instance_variable_get(:@head)
        tail = queue.instance_variable_get(:@tail)

        expect(head).to be_nil
        expect(tail).to be_nil
        expect(queue.empty?).to be true
      end
    end
  end

  describe 'interleaved enqueue and dequeue' do
    it 'works correctly when enqueue after some dequeues' do
      queue.enqueue(1)
      queue.enqueue(2)

      expect(queue.dequeue).to eq(1)

      queue.enqueue(3)

      expect(queue.dequeue).to eq(2)
      expect(queue.dequeue).to eq(3)
      expect(queue.dequeue).to be_nil
      expect(queue.empty?).to be true
    end

    it 'supports multiple cycles of fill and drain' do
      3.times do |round|
        values = (1..5).map { |i| "#{round}-#{i}" }
        values.each { |v| queue.enqueue(v) }

        dequeued = []
        # 将本轮入队的 5 个元素全部出队
        5.times { dequeued << queue.dequeue }

        expect(dequeued).to eq(values)
        expect(queue.empty?).to be true
      end
    end
  end

  describe 'stress / basic performance sanity check' do
    it 'can handle many operations without breaking linkage' do
      n = 1000

      n.times { |i| queue.enqueue(i) }
      expect(queue.empty?).to be false

      # 出队一半
      (n / 2).times do |i|
        expect(queue.dequeue).to eq(i)
      end

      # 现在队首应该是 n/2
      head = queue.instance_variable_get(:@head)
      expect(head.val).to eq(n / 2)

      # 再入队 n 个新元素
      n.times { |i| queue.enqueue("x#{i}") }

      # 把剩下元素全出队（不做严格顺序检查，只要不 crash）
      until queue.empty?
        queue.dequeue
      end

      expect(queue.empty?).to be true
    end
  end
end