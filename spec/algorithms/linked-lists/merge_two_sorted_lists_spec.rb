# spec/algorithms/linked-lists/merge_two_sorted_lists_spec.rb
require "spec_helper"

RSpec.describe "merge_two_sorted_lists" do
  include Algorithms::LinkedLists

  describe "#merge_two_sorted_lists" do
    context "when both lists are empty" do
      it "returns nil" do
        merged = merge_two_sorted_lists(nil, nil)
        expect(merged).to be_nil
      end
    end

    context "when one list is empty" do
      it "returns the other list when l1 is empty" do
        l1 = nil
        l2 = build_linked_list([1, 3, 5])
        merged = merge_two_sorted_lists(l1, l2)

        expect(list_to_array(merged)).to eq([1, 3, 5])
      end

      it "returns the other list when l2 is empty" do
        l1 = build_linked_list([2, 4, 6])
        l2 = nil
        merged = merge_two_sorted_lists(l1, l2)

        expect(list_to_array(merged)).to eq([2, 4, 6])
      end
    end

    context "when both lists have one node" do
      it "merges them in ascending order" do
        l1 = build_linked_list([1])
        l2 = build_linked_list([2])

        merged = merge_two_sorted_lists(l1, l2)

        expect(list_to_array(merged)).to eq([1, 2])
      end

      it "merges them correctly when l1 > l2" do
        l1 = build_linked_list([5])
        l2 = build_linked_list([3])

        merged = merge_two_sorted_lists(l1, l2)

        expect(list_to_array(merged)).to eq([3, 5])
      end
    end

    context "when both lists have multiple nodes" do
      it "merges two ascending lists into one ascending list" do
        l1 = build_linked_list([1, 2, 4])
        l2 = build_linked_list([1, 3, 4])

        merged = merge_two_sorted_lists(l1, l2)

        expect(list_to_array(merged)).to eq([1, 1, 2, 3, 4, 4])
      end

      it "handles lists with interleaving values" do
        l1 = build_linked_list([1, 4, 7])
        l2 = build_linked_list([2, 3, 6, 8])

        merged = merge_two_sorted_lists(l1, l2)

        expect(list_to_array(merged)).to eq([1, 2, 3, 4, 6, 7, 8])
      end

      it "handles duplicate values across lists" do
        l1 = build_linked_list([1, 2, 2])
        l2 = build_linked_list([2, 2, 3])

        merged = merge_two_sorted_lists(l1, l2)

        expect(list_to_array(merged)).to eq([1, 2, 2, 2, 2, 3])
      end

      it "handles negative numbers and zeros" do
        l1 = build_linked_list([-3, -1, 0])
        l2 = build_linked_list([-2, 1, 2])

        merged = merge_two_sorted_lists(l1, l2)

        expect(list_to_array(merged)).to eq([-3, -2, -1, 0, 1, 2])
      end
    end

    it "does not create new nodes and reuses the existing ones" do
      l1 = build_linked_list([1, 3, 5])
      l2 = build_linked_list([2, 4, 6])

      before_ids = node_object_ids(l1) + node_object_ids(l2)

      merged = merge_two_sorted_lists(l1, l2)
      after_ids = node_object_ids(merged)

      expect(after_ids.size).to eq(before_ids.size)
      expect(after_ids.sort).to eq(before_ids.sort)
    end
  end
end