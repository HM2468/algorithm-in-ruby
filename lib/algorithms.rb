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
    require_relative "algorithms/linked_lists/remove_nth_node_from_end"
  end

  module LinkedQueue
    require_relative "algorithms/linked_queue/queue"
  end

  module LinkedStack
    require_relative "algorithms/linked_stack/stack"
    require_relative "algorithms/linked_stack/mini_stack"
    require_relative "algorithms/linked_stack/valid_parentheses"
    require_relative "algorithms/linked_stack/daily_temperature"
  end

  module BinaryTree
    require_relative "algorithms/binary_tree/basic"
    require_relative "algorithms/binary_tree/bfs"
    require_relative "algorithms/binary_tree/dfs"
  end

  module Sorting
    require_relative "algorithms/sorting/sorting"
  end

  module DP
    require_relative "algorithms/dp/01_climbing_stairs"
    require_relative "algorithms/dp/02_min_cost_climbing_stairs"
    require_relative "algorithms/dp/03_house_robber"
  end
end