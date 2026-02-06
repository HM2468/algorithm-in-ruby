# frozen_string_literal: true

=begin
1043. Partition Array for Maximum Sum

Given an integer array arr and an integer k, partition the array into
contiguous subarrays, each of length at most k.

After partitioning, each subarray contributes:
  (max value in that subarray) * (length of that subarray)

Return the maximum sum after partitioning.

------------------------------------------------------------
Conventions (point-based DP, non-constant transition):
  - n = arr.length
  - arr[i] is the i-th element (0-based)

State meaning:
  dp[i] = maximum sum for subarray arr[0..i]

Base case:
  dp[i] >= arr[i]   (at minimum, arr[i] alone forms a partition)
  dp[-1] is treated as 0 (used implicitly)

Transition (non-constant):
  For each i, try all partition lengths len in [1..k]:
    - The partition ends at i
    - It starts at j = i - len + 1 (j >= 0)
    - max_val = max(arr[j..i])
    - candidate = dp[j-1] + max_val * len

  dp[i] = max over all valid candidates

Final answer:
  dp[n-1]

Why "non-constant transition"?
  For each i, we must iterate over up to k previous elements to
  evaluate all possible partitions ending at i.

------------------------------------------------------------
Time Complexity:
  - memoization : O(n * k)
  - tabulation  : O(n * k)

Space Complexity:
  - memoization : O(n) memo + recursion stack
  - tabulation  : O(n)

@param arr [Array<Integer>]
@param k   [Integer]
@return [Integer]
=end

module DP
  class PartitionArrayForMaximumSum
    # Memoization (top-down)
    #
    # dp(i): maximum sum for arr[0..i]
    #
    # Time:  O(n * k)
    # Space: O(n) memo + recursion stack
    def memoization(arr, k)
      validate_inputs!(arr, k)
      n = arr.length
      return 0 if n == 0

      @arr = arr
      @k   = k
      @memo = Array.new(n, nil)

      dp(n - 1)
    end

    # Tabulation (bottom-up)
    #
    # dp[i]: maximum sum for arr[0..i]
    #
    # Time:  O(n * k)
    # Space: O(n)
    def tabulation(arr, k)
      validate_inputs!(arr, k)
      n = arr.length
      return 0 if n == 0

      dp = Array.new(n, 0)

      (0...n).each do |i|
        max_val = 0

        # try all partitions ending at i, with length 1..k
        (1..k).each do |len|
          j = i - len + 1
          break if j < 0

          max_val = [max_val, arr[j]].max
          prev = (j > 0) ? dp[j - 1] : 0
          dp[i] = [dp[i], prev + max_val * len].max
        end
      end

      dp[n - 1]
    end

    private

    # dp(i): maximum sum for arr[0..i]
    def dp(i)
      return 0 if i < 0

      cached = @memo[i]
      return cached unless cached.nil?

      best = 0
      max_val = 0

      (1..@k).each do |len|
        j = i - len + 1
        break if j < 0

        max_val = [max_val, @arr[j]].max
        best = [best, dp(j - 1) + max_val * len].max
      end

      @memo[i] = best
    end

    def validate_inputs!(arr, k)
      raise ArgumentError, "arr must be an Array" unless arr.is_a?(Array)
      raise ArgumentError, "k must be a positive integer" unless k.is_a?(Integer) && k > 0
      unless arr.all? { |x| x.is_a?(Integer) }
        raise ArgumentError, "arr elements must be integers"
      end
    end
  end
end



=begin

1) dp[i] 是什么？

这里我们用的是点状态 DP：
dp[i] = 把 arr[0..i] 这段前缀切分完之后，能得到的最大总和
注意：dp[i] 只管到 i 为止，后面不关心。

2) 为什么要枚举 len = 1..k？

因为题目规定：每一段 partition 的长度最多是 k。
当我们要算 dp[i] 时，最后一步一定是：
最后一段 partition “以 i 结尾”（因为我们正好要覆盖到 i）
但最后一段的长度可以不同：
	•	长度 1：最后一段是 arr[i..i]
	•	长度 2：最后一段是 arr[i-1..i]
	•	…
	•	长度 k：最后一段是 arr[i-k+1..i]（前提不越界）

所以我们要把 所有可能的最后一段长度都试一遍，取最大。

这就是：

(1..k).each do |len|

3) j = i - len + 1 是怎么来的？

如果最后一段长度是 len，并且它以 i 结束，那么它的起点 j 是：
	•	这段一共有 len 个元素
	•	最后一个元素下标是 i
	•	起点下标 = i - (len - 1) = i - len + 1
所以：
j = i - len + 1
并且必须 j >= 0，否则越界（说明这个 len 太长，不合法）。

4) max_val = max(arr[j..i]) 是什么意思？

题目说：每一段贡献值 = 这一段的最大值 × 这一段长度

所以如果最后一段是 arr[j..i]：
	•	max_val = max(arr[j..i])
	•	这一段贡献 = max_val * len

5) candidate = dp[j-1] + max_val * len 是什么意思？

把整个 arr[0..i] 切分，可以理解为：
	•	前面部分：arr[0..j-1]
	•	最后一段：arr[j..i]

前面部分的最优值就是 dp[j-1]（如果 j=0，那么前面没东西，记为 0）。

最后一段的贡献就是 max_val * len。
所以如果我们选择“最后一段从 j 到 i”，总和就是：
candidate = dp[j-1] + (max(arr[j..i]) * len)
然后我们要在所有合法 len 里取最大：
dp[i] = max(candidate over all len)


6) 来一遍完整计算（最重要）

用题目经典例子：
arr = [1, 15, 7, 9, 2, 5, 10], k = 3
我们算到 i = 3（也就是前缀 [1, 15, 7, 9]），看看 dp[3] 怎么来。
i = 3，len 可以是 1..3

✅ len = 1
	•	j = 3 - 1 + 1 = 3
	•	最后一段 arr[3..3] = [9]
	•	max_val = 9
	•	candidate = dp[2] + 9*1
✅ len = 2
	•	j = 3 - 2 + 1 = 2
	•	最后一段 arr[2..3] = [7, 9]
	•	max_val = 9
	•	candidate = dp[1] + 9*2
✅ len = 3
	•	j = 3 - 3 + 1 = 1
	•	最后一段 arr[1..3] = [15, 7, 9]
	•	max_val = 15
	•	candidate = dp[0] + 15*3

然后：

dp[3] = max( dp[2] + 9,
             dp[1] + 18,
             dp[0] + 45 )
你可以看到：不同 len 会导致：
	•	切分点 j 不同
	•	max_val 不同
	•	前缀 dp[j-1] 不同
	•	总和 candidate 不同
最后取最大的那个方案，就是 dp[3] 的最优切法。

7) 为什么说是 Non-constant transition？

因为算 dp[i] 时，不是 O(1) 就能确定，它要试 len=1..k：
	•	对每个 i 要做最多 k 次尝试
	•	所以转移代价是 O(k)
	•	总体 O(n*k)
这就是“non-constant transition”。

8) 把核心一句话记牢

dp[i] 的本质：枚举最后一段怎么切
每种切法 = “前缀最优 dp[j-1]” + “最后一段贡献 max*len”取最大。
=end
