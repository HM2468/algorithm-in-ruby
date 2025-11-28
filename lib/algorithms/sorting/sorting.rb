# lib/algorithms/sorting/sorting.rb

module Algorithms
  module Sorting

    # Bubble Sort
    # 外层循环控制“趟数”
    # 第 1 趟把最大的元素“冒泡”到最后
    # 第 2 趟把第二大的“冒泡”到倒数第二个...
    # 内层循环负责比较相邻的两个元素
    # 已经冒泡到最后的 i 个元素不用再管，所以是 (0...n - 1 - i)
    def bubble_sort!(arr)
      n = arr.length
      (0...n-1).each do |i|
        (0...(n-1-i)).each do |j|
          if arr[j] > arr[j + 1]
            arr[j], arr[j + 1] = arr[j + 1], arr[j]
          end
        end
      end
      arr
    end

    # 原地选择排序（从小到大）
    # 外层循环控制“趟数”
    # 第 1 趟把最小的元素“选择”到最前
    # 第 2 趟把第二小的“选择”到第二个...
    # 内层循环负责在未排序的元素中找最小的
    # @param arr [Array<Integer>]
    # @return [Array<Integer>]
    def selection_sort!(arr)
      n = arr.length
      (0...(n-1)).each do |i|
        min_idx = i
        ((i+1)...n).each do |j|
          min_idx = j if arr[j] < arr[min_idx]
        end
        arr[i], arr[min_idx] = arr[min_idx], arr[i] if min_idx != i
      end
      arr
    end

    # 原地插入排序（从小到大）
    # 外层循环控制“趟数”
    # 第 1 趟把第二个元素“插入”到第一个元素的左边
    # 第 2 趟把第三个元素“插入”到前两个元素的合适位置...
    # 内层循环负责在已排序的元素中找合适位置
    # @param arr [Array<Integer>]
    # @return [Array<Integer>]
    def insertion_sort!(arr)
      # i 从 1 开始到数组最后一个索引
      (1...arr.length).each do |i|
        value = arr[i]
        hole  = i
        # 向前“挖坑”并后移元素
        while hole > 0 && arr[hole - 1] > value
          arr[hole] = arr[hole - 1]
          hole -= 1
        end
        # 把当前元素插入到合适的位置
        arr[hole] = value
      end
      arr
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

    # 原地快速排序：直接在 arr 上排序
    def quick_sort!(arr, first, last)
      # 当区间内至少有 2 个元素时才需要排序
      if first < last
        # 1. 先对 [first, last] 这段做 partition
        # partition 会把 pivot 放到正确位置，并返回 pivot 的下标 p
        p = partition(arr, first, last)
        # 2. 递归排序 pivot 左边和右边的两段
        quick_sort!(arr, first, p - 1)
        quick_sort!(arr, p + 1, last)
      end
      arr
    end

    # 分区函数：使用 Lomuto 分区方案
    # 约定：pivot 就是 arr[last]（最后一个元素）
    # 作用：
    #   - 扫描 [first, last-1] 区间，把 <= pivot 的元素都移动到前面
    #   - 最后把 pivot 放到中间的位置
    #   - 返回 pivot 最终所在的下标
    def partition(arr, first, last)
      pivot = arr[last]
      p_idx = first
      (first...last).each do |j|
        if arr[j] <= pivot
          arr[p_idx], arr[j] = arr[j], arr[p_idx]
          p_idx += 1
        end
      end
      arr[p_idx], arr[last] = arr[last], arr[p_idx]
      p_idx
    end

  end
end