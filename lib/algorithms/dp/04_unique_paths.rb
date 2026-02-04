# frozen_string_literal: true

=begin
62. Unique Paths

Conventions (strictly 0-based):
  - m: number of rows    (height)
  - n: number of columns (width)

Grid indexing:
  grid[row][col], where:
    row in 0..(m-1)
    col in 0..(n-1)

@param m [Integer] rows
@param n [Integer] cols
@return [Integer]

Start:  (0, 0)
Finish: (m-1, n-1)
Moves:  DOWN => (row + 1, col), RIGHT => (row, col + 1)

Goal:
  Return the number of unique paths from (0,0) to (m-1,n-1).

DP model (classic):
  paths[r][c] = paths[r-1][c] + paths[r][c-1]
  with base row/col = 1
=end

module DP
  class UniquePaths
    # Memoization (top-down)
    #
    # dp(r, c): number of unique paths to reach cell (r, c) from start (0,0)
    # Using 0-based indices everywhere.
    #
    # Base:
    #   dp(0, c) = 1
    #   dp(r, 0) = 1
    #
    # Transition:
    #   dp(r, c) = dp(r-1, c) + dp(r, c-1)
    #
    # Time:  O(m*n)
    # Space: O(m*n) for memo + recursion stack O(m+n)
    def memoization_unique_paths(m, n)
      validate_mn!(m, n)
      @memo = Array.new(m) { Array.new(n, 0) } # 0 means "not computed yet"
      memo_dp(m - 1, n - 1)
    end

    # Tabulation (bottom-up) - full 2D table
    #
    # paths[r][c]: number of unique paths from start (0,0) to cell (r,c)
    #
    # Time:  O(m*n)
    # Space: O(m*n)
    def tabulation_unique_paths(m, n)
      validate_mn!(m, n)

      paths = Array.new(m) { Array.new(n, 0) }

      # First row: only can come from left (all RIGHT moves)
      (0...n).each do |c|
        paths[0][c] = 1
      end

      # First column: only can come from above (all DOWN moves)
      (0...m).each do |r|
        paths[r][0] = 1
      end

      # Transition:
      # paths[r][c] = paths[r-1][c] (from above) + paths[r][c-1] (from left)
      (1...m).each do |r|
        (1...n).each do |c|
          paths[r][c] = paths[r - 1][c] + paths[r][c - 1]
        end
      end

      paths[m - 1][n - 1]
    end

    # Tabulation (bottom-up) - 1D optimized
    #
    # Use a 1D array dp where dp[c] represents the number of paths for current row at column c.
    # Update rule (left-to-right):
    #   dp[c] = dp[c] (from above) + dp[c-1] (from left)
    #
    # We can choose the smaller dimension as the DP width to achieve O(min(m,n)) space:
    #   width = min(m, n)
    #   height = max(m, n)
    #
    # Time:  O(m*n)
    # Space: O(min(m,n))
    def tabulation_unique_paths_1d(m, n)
      validate_mn!(m, n)

      width  = [m, n].min
      height = [m, n].max

      # dp[c] for c in 0..width-1
      # Initialize first row (or first "height-iteration"): all 1s
      dp = Array.new(width, 1)

      # For each additional row (height dimension), update dp in-place
      # Starting from row index 1 because row 0 is already all ones.
      (1...height).each do |_|
        (1...width).each do |c|
          dp[c] = dp[c] + dp[c - 1]
        end
      end

      dp[width - 1]
    end

    private

    # memo_dp(r, c): number of unique paths from start (0,0) to cell (r,c)
    # (0-based indices)
    def memo_dp(r, c)
      return 1 if r == 0 || c == 0

      cache = @memo[r][c]
      return cache unless cache.zero?

      @memo[r][c] = memo_dp(r - 1, c) + memo_dp(r, c - 1)
    end

    def validate_mn!(m, n)
      unless m.is_a?(Integer) && m > 0 && n.is_a?(Integer) && n > 0
        raise ArgumentError, "m (rows) and n (cols) must be positive integers"
      end
    end
  end
end