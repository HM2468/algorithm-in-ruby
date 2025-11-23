# spec/algorithms/linked-lists/has_cycle_spec.rb
require "spec_helper"

RSpec.describe "has_cycle?" do
  include Algorithms::LinkedLists

  describe "#has_cycle?" do
    context "when the list is empty" do
      it "returns false" do
        expect(has_cycle?(nil)).to be(false)
      end
    end

    context "when the list has only one node" do
      it "returns false if there is no cycle" do
        head = build_linked_list([1])
        expect(has_cycle?(head)).to be(false)
      end

      it "returns true if the node points to itself" do
        head = build_linked_list([1])
        head.next = head

        expect(has_cycle?(head)).to be(true)
      end
    end

    context "when the list has multiple nodes and no cycle" do
      it "returns false" do
        head = build_linked_list([1, 2, 3, 4, 5])
        expect(has_cycle?(head)).to be(false)
      end
    end

    context "when the list has a cycle" do
      it "returns true when the cycle starts at the head (pos = 0)" do
        head = build_cyclic_list([1, 2, 3, 4], 0)
        expect(has_cycle?(head)).to be(true)
      end

      it "returns true when the cycle starts in the middle (pos = 1)" do
        head = build_cyclic_list([3, 2, 0, -4], 1)
        expect(has_cycle?(head)).to be(true)
      end

      it "returns true when the cycle is at the last node pointing back to earlier node" do
        head = build_cyclic_list([1, 2, 3, 4, 5], 2) # tail -> node with value 3
        expect(has_cycle?(head)).to be(true)
      end
    end
  end
end