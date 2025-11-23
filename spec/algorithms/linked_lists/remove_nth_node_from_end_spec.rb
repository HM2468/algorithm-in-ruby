# spec/algorithms/linked-lists/remove_nth_from_end_spec.rb
require "spec_helper"

RSpec.describe "remove_nth_from_end" do
  include Algorithms::LinkedLists

  describe "#remove_nth_node_from_end" do
    context "when the list has multiple nodes" do
      it "removes the nth node from the end in the middle of the list" do
        head = build_linked_list([1, 2, 3, 4, 5])
        # 删除倒数第 2 个（值为 4）
        new_head = remove_nth_from_end(head, 2)

        expect(list_to_array(new_head)).to eq([1, 2, 3, 5])
      end

      it "removes the last node when n = 1" do
        head = build_linked_list([1, 2, 3])
        new_head = remove_nth_from_end(head, 1)

        expect(list_to_array(new_head)).to eq([1, 2])
      end

      it "removes the head when n equals the list length" do
        head = build_linked_list([1, 2, 3, 4])
        # 删除倒数第 4 个，即头结点 1
        new_head = remove_nth_from_end(head, 4)

        expect(list_to_array(new_head)).to eq([2, 3, 4])
      end
    end

    context "when the list has only one node" do
      it "returns nil when removing the only node" do
        head = build_linked_list([42])
        new_head = remove_nth_from_end(head, 1)

        expect(new_head).to be_nil
      end
    end

    context "when n is greater than the length of the list" do
      it "raises an ArgumentError" do
        head = build_linked_list([1, 2, 3])

        expect {
          remove_nth_from_end(head, 5)
        }.to raise_error(ArgumentError, /less than n/)
      end
    end

    it "removes exactly one node and does not create new nodes" do
      head = build_linked_list([1, 2, 3, 4, 5])
      before_ids = node_object_ids(head)

      new_head = remove_nth_from_end(head, 3) # 删除中间的 3
      after_ids = node_object_ids(new_head)

      # 节点数量少了一个
      expect(after_ids.size).to eq(before_ids.size - 1)
      # 删除之外的节点仍然是原来的对象
      after_ids.each do |id|
        expect(before_ids).to include(id)
      end
    end

    it "works correctly when removing different positions in the same list shape" do
      # 删除尾、头、中间各测一遍
      original = [10, 20, 30, 40]

      # 删除尾部（n = 1）
      head1 = build_linked_list(original)
      new_head1 = remove_nth_from_end(head1, 1)
      expect(list_to_array(new_head1)).to eq([10, 20, 30])

      # 删除头部（n = 4）
      head2 = build_linked_list(original)
      new_head2 = remove_nth_from_end(head2, 4)
      expect(list_to_array(new_head2)).to eq([20, 30, 40])

      # 删除中间某个（n = 2，删除 30）
      head3 = build_linked_list(original)
      new_head3 = remove_nth_from_end(head3, 2)
      expect(list_to_array(new_head3)).to eq([10, 20, 40])
    end
  end
end