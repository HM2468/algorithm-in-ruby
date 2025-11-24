# lib/algorithms/sorting/sorting.rb

module Algorithms
  module Sorting

    # Bubble Sort
    # @param arr [Array<Integer>]
    # @return [Array<Integer>]
    def bubble_sort(arr)
      # 为了不改动传进来的原数组，先拷贝一份
      a = arr.dup
      n = a.length
      return a if n <= 1
      # 外层循环控制“趟数”
      # 第 1 趟把最大的元素“冒泡”到最后
      # 第 2 趟把第二大的“冒泡”到倒数第二个...
      (0...n - 1).each do |i|
        # 这一趟是否发生过交换，用于优化
        swapped = false
        # 内层循环负责比较相邻的两个元素
        # 已经冒泡到最后的 i 个元素不用再管，所以是 (0...n - 1 - i)
        (0...n - 1 - i).each do |j|
          # 如果前一个比后一个大，就交换
          if a[j] > a[j + 1]
            a[j], a[j + 1] = a[j + 1], a[j]
            swapped = true
          end
        end
        # 如果这一趟一次交换都没发生，说明已经有序了，可以提前结束
        break unless swapped
      end
      a
    end


  end
end