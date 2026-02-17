# frozen_string_literal: true

=begin
Dice Walk (exactly hit cell n)

Problem:
  A person starts at cell 0.
  Each roll of a fair 6-sided die yields a value in {1,2,3,4,5,6}.
  If the roll is k, the person moves forward k cells.
  The person may roll indefinitely.
  Question: What is the probability of ever landing exactly on cell n?

Model:
  Let X_i ~ Uniform{1..6} i.i.d. be each die roll.
  Let S_t = X_1 + ... + X_t be the position after t rolls.
  Because steps are strictly positive, positions are strictly increasing.
  Therefore:
    "ever land exactly on n"  <=>  "there exists some t with S_t = n".

DP definition (point-based DP / index-based DP):
  - n: target cell (0-based)
  - p(n): probability that starting from cell 0, we ever hit exactly cell n

State meaning:
  p(i) = probability of ever hitting exactly cell i (starting from 0)

Base cases:
  p(0) = 1     # already at 0
  p(i) = 0 for i < 0

Transition:
  To land exactly on cell i (i >= 1),
  the last roll must be k in {1..6} and we must have been at cell i-k before that roll.
  Since each k occurs with probability 1/6:

    p(i) = (1/6) * ( p(i-1) + p(i-2) + p(i-3) + p(i-4) + p(i-5) + p(i-6) )

We provide multiple implementations:
  1) memoization    : top-down recursion with caching
  2) tabulation_1   : bottom-up DP array (O(n) space)
  3) tabulation_2   : bottom-up rolling window (O(1) space)

Time Complexity:
  - All implementations: O(n)

Space Complexity:
  - memoization    : O(n) recursion + O(n) cache
  - tabulation_1   : O(n)
  - tabulation_2   : O(1)

@param n [Integer] target cell (n >= 0)
@return [Float] probability in [0,1]
=end

module DP
  class DiceWalkHitProbability
    SIDES = 6

    # Top-down recursion + memo
    def memoization(n)
      validate_n!(n)
      return 1.0 if n == 0

      @memo_p ||= {}
      return @memo_p[n] if @memo_p.key?(n)

      sum = 0.0
      1.upto(SIDES) do |k|
        prev = n - k
        sum += (prev >= 0 ? memoization(prev) : 0.0)
      end

      @memo_p[n] = sum / SIDES
    end

    # Bottom-up DP array (O(n) space)
    def tabulation_1(n)
      validate_n!(n)

      p = Array.new(n + 1, 0.0)
      p[0] = 1.0

      1.upto(n) do |i|
        sum = 0.0
        1.upto(SIDES) do |k|
          j = i - k
          sum += p[j] if j >= 0
        end
        p[i] = sum / SIDES
      end

      p[n]
    end

    # Bottom-up with rolling window (O(1) space)
    #
    # Maintain the last 6 probabilities:
    #   at step i, we need p[i-1]..p[i-6]
    #
    # window holds [p[i-6], p[i-5], ..., p[i-1]] (length 6).
    def tabulation_2(n)
      validate_n!(n)
      return 1.0 if n == 0

      window = Array.new(SIDES, 0.0)
      # For i=1, the needed previous values are:
      # p[0], p[-1], ..., p[-5]  =>  [0,0,0,0,0,1] in window order [p[-5]..p[0]]
      window[-1] = 1.0

      sum = window.sum # sum of the last 6 probabilities

      1.upto(n) do
        p_next = sum / SIDES

        dropped = window.shift
        window << p_next

        sum = sum - dropped + p_next
      end

      window[-1] # p[n]
    end

    private

    def validate_n!(n)
      raise ArgumentError, "n must be a non-negative integer" unless n.is_a?(Integer) && n >= 0
    end
  end
end

# ---- Example usage ----
# solver = DP::DiceWalkHitProbability.new
# n = 2023
# p2023 = solver.tabulation_2(n)
# puts "p[#{n}] = #{format('%.18f', p2023)}"
# puts "2/7     = #{format('%.18f', 2.0 / 7)}"
# puts "diff    = #{(p2023 - 2.0 / 7).abs}"