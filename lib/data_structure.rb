module DataStructure

  module LinkedLists
    require_relative "data_structure/linked_lists/basic"
    require_relative "data_structure/linked_lists/detect_cycle"
    require_relative "data_structure/linked_lists/has_cycle"
    require_relative "data_structure/linked_lists/merge_two_sorted_list"
    require_relative "data_structure/linked_lists/palindrome"
    require_relative "data_structure/linked_lists/reverse_linked_list"
    require_relative "data_structure/linked_lists/reverse_k_group"
    require_relative "data_structure/linked_lists/recursive_print"
    require_relative "data_structure/linked_lists/remove_nth_node_from_end"
  end

  module LinkedQueue
    require_relative "data_structure/linked_queue/queue"
  end

  module LinkedStack
    require_relative "data_structure/linked_stack/00_stack"
    require_relative "data_structure/linked_stack/01_mini_stack"
    require_relative "data_structure/linked_stack/02_valid_parentheses"
    require_relative "data_structure/linked_stack/03_daily_temperature"
  end

  module BinaryTree
    require_relative "data_structure/binary_tree/basic"
    require_relative "data_structure/binary_tree/bfs"
    require_relative "data_structure/binary_tree/dfs"
  end
end