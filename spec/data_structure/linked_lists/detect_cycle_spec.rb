# spec/data_structure/linked-lists/detect_cycle_spec.rb
require "spec_helper"

RSpec.describe "detect_cycle" do
  include DataStructure::LinkedLists

  describe "#detect_cycle" do
    context "when the list is empty" do
      it "returns nil" do
        expect(detect_cycle(nil)).to be_nil
      end
    end

    context "when the list has no cycle" do
      it "returns nil" do
        head = build_linked_list([1, 2, 3, 4, 5])
        expect(detect_cycle(head)).to be_nil
      end
    end

    context "when the list has a self-loop on a single node" do
      it "returns that node as the cycle entry" do
        head = build_linked_list([10])
        head.next = head

        entry = detect_cycle(head)
        expect(entry).to equal(head)
        expect(entry.val).to eq(10)
      end
    end

    context "when the cycle starts at the head (pos = 0)" do
      it "returns the head node" do
        head = build_cyclic_list([1, 2, 3, 4], 0)

        entry = detect_cycle(head)

        expect(entry).to equal(head)
        expect(entry.val).to eq(1)
      end
    end

    context "when the cycle starts in the middle" do
      it "returns the correct entry node" do
        # 链表：3 -> 2 -> 0 -> -4 -> 指回下标 1（值为 2）
        values = [3, 2, 0, -4]
        head   = build_cyclic_list(values, 1)

        entry        = detect_cycle(head)
        expected_node = node_at(head, 1)

        expect(entry).to equal(expected_node)
        expect(entry.val).to eq(2)
      end
    end
  end
end