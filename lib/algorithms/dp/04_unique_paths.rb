=begin
62. Unique Paths

Conventions (strictly 0-based):
  - m: number of rows    (height)
  - n: number of columns (width)

Grid indexing:
  grid[row][col], where:
    row in 0..(m-1)
    col in 0..(n-1)

Start:  (0, 0)
Finish: (m-1, n-1)
Moves:  DOWN => (row + 1, col), RIGHT => (row, col + 1)
=end

module DP
  class UniquePaths
    # Memoization (top-down, 0-based indices everywhere)
    #
    # dp(r, c): number of unique paths from cell (r, c) to finish (m-1, n-1)
    #
    # @param m [Integer] rows
    # @param n [Integer] cols
    # @return [Integer]
    def memoization_unique_paths(m, n)
      validate_mn!(m, n)
      @memo = Array.new(m) { Array.new(n, 0) }
      dp(m - 1, n - 1)
    end

    # Tabulation (bottom-up, 0-based indices)
    #
    # paths[r][c]: number of unique paths from start (0,0) to cell (r,c)
    #
    # @param m [Integer] rows
    # @param n [Integer] cols
    # @return [Integer]
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

    private

    # dp(r, c): paths from (r, c) to finish (rows-1, cols-1)
    def dp(r, c)
      return 1 if r == 0 || c == 0

      cache = @memo[r][c]
      return cache unless cache.zero?

      @memo[r][c] = dp(r - 1, c) + dp(r, c - 1)
    end

    def validate_mn!(m, n)
      unless m.is_a?(Integer) && m > 0 && n.is_a?(Integer) && n > 0
        raise ArgumentError, "m (rows) and n (cols) must be positive integers"
      end
    end
  end
end