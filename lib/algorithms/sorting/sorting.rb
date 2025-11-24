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

    # Merge Sort
    # usually done recursively
    # divide and conquer
    # @param arr [Array<Integer>]
    # @return [Array<Integer>]
    def merge_sort(arr)
      # 0 个或 1 个元素的数组，天然有序，直接返回
      return arr if arr.length <= 1

      # 1. 把数组从中间劈成两半
      mid = arr.length / 2
      left  = arr[0...mid]
      right = arr[mid...arr.length]

      # 2. 递归地对左右两边分别做归并排序
      sorted_left  = merge_sort(left)
      sorted_right = merge_sort(right)

      # 3. 合并两个有序数组
      merge(sorted_left, sorted_right)
    end

    def merge(left, right)
      result = []
      i = 0 # left 的指针
      j = 0 # right 的指针
      # 两边都有剩余元素时，不停比较当前最小的那个
      while i < left.length && j < right.length
        if left[i] <= right[j]
          result << left[i]
          i += 1
        else
          result << right[j]
          j += 1
        end
      end
      # 把剩下没用完的元素全部接到后面
      # (事实上下面两个只会执行一个，因为要么 left 用完，要么 right 用完)
      while i < left.length
        result << left[i]
        i += 1
      end
      while j < right.length
        result << right[j]
        j += 1
      end
      result
    end


  end
end