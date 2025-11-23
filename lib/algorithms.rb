module Algorithms
  module Strings
    require_relative "algorithms/strings/longest_palindrome"
    require_relative "algorithms/strings/longest_substring"
  end

  module LinkedLists
    require_relative "algorithms/linked_lists/basic"
    require_relative "algorithms/linked_lists/detect_cycle"
    require_relative "algorithms/linked_lists/has_cycle"
    require_relative "algorithms/linked_lists/merge_two_sorted_list"
    require_relative "algorithms/linked_lists/palindrome"
    require_relative "algorithms/linked_lists/reverse_linked_list"
    require_relative "algorithms/linked_lists/reverse_k_group"
    require_relative "algorithms/linked_lists/recursive_print"
  end

  module LinkedQueue
    require_relative "algorithms/linked_queue/queue"
  end

  module LinkedStack
    require_relative "algorithms/linked_stack/stack"
    require_relative "algorithms/linked_stack/valid_parentheses"
  end

  module BinaryTree
    require_relative "algorithms/binary_tree/basic"
    require_relative "algorithms/binary_tree/depth_first_traversal"
  end
end