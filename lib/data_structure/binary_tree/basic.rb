module DataStructure
  module BinaryTree
    Node = Struct.new(:val, :left, :right)

    # height: 当前节点为根的子树高度
    HeightNode = Struct.new(:val, :left, :right, :height)
  end
end