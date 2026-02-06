# frozen_string_literal: true

# frozen_string_literal: true

=begin
63. Unique Paths II

You are given an m x n grid with obstacles.
A robot starts at the top-left corner (0,0) and wants to reach the bottom-right corner (m-1,n-1).
The robot can only move DOWN or RIGHT.
An obstacle is marked as 1; a free cell is 0.
Return the number of unique paths.

Conventions (point-based / 2D index-based DP with obstacles):
  - m: number of rows
  - n: number of columns
  - Grid indices are 0-based:
      row in 0..(m-1)
      col in 0..(n-1)
  - obstacle_grid[r][c] == 1 means the cell is blocked (cannot step on it)
  - Start:  (0, 0)
  - Finish: (m-1, n-1)

State meaning:
  dp[r][c] = number of unique paths to reach cell (r, c) from start (0, 0)
            while never stepping onto an obstacle

Obstacle rule:
  If obstacle_grid[r][c] == 1, then dp[r][c] = 0 (no ways to stand on a blocked cell)

Base cases:
  - If start is blocked: answer is 0
  - dp[0][0] = 1 if start is free

  For the first row (r = 0):
    dp[0][c] is either:
      - 0 if obstacle at (0,c), OR
      - dp[0][c-1] otherwise
    (Because the robot can only come from the left on the first row.)

  For the first column (c = 0):
    dp[r][0] is either:
      - 0 if obstacle at (r,0), OR
      - dp[r-1][0] otherwise
    (Because the robot can only come from above on the first column.)

Transition:
  For any free cell (r, c) where r > 0 and c > 0:
    dp[r][c] = dp[r-1][c] + dp[r][c-1]

Final answer:
  dp[m-1][n-1]

We provide multiple implementations:
  1) memoization  : top-down recursion with caching (O(m*n) memo)
  2) tabulation   : bottom-up full 2D DP table (O(m*n) space)
  3) tabulation_1d: bottom-up optimized with a rolling 1D array (O(n) space)

Time Complexity:
  - All implementations: O(m * n)

Space Complexity:
  - memoization  : O(m * n) memo + recursion stack O(m + n)
  - tabulation   : O(m * n)
  - tabulation_1d: O(n)

@param obstacle_grid [Array<Array<Integer>>] values must be 0 or 1
@return [Integer] number of unique paths
=end

module DP
  class UniquePathsII
    # Memoization (top-down)
    #
    # dp(r, c): number of paths from (0,0) to (r,c)
    #
    # Time:  O(m*n)
    # Space: O(m*n) memo + recursion stack O(m+n)
    def memoization(obstacle_grid)
      validate_grid!(obstacle_grid)

      m = obstacle_grid.size
      n = obstacle_grid[0].size

      return 0 if obstacle_grid[0][0] == 1
      return 0 if obstacle_grid[m - 1][n - 1] == 1

      @grid = obstacle_grid
      @memo = Array.new(m) { Array.new(n, nil) } # nil means "not computed yet"
      dp(m - 1, n - 1)
    end

    # Tabulation (bottom-up) - full 2D table
    #
    # paths[r][c]: number of unique paths from start (0,0) to cell (r,c)
    #
    # Time:  O(m*n)
    # Space: O(m*n)
    def tabulation(obstacle_grid)
      validate_grid!(obstacle_grid)

      m = obstacle_grid.size
      n = obstacle_grid[0].size

      return 0 if obstacle_grid[0][0] == 1

      paths = Array.new(m) { Array.new(n, 0) }
      paths[0][0] = 1

      # First row
      (1...n).each do |c|
        paths[0][c] = obstacle_grid[0][c] == 1 ? 0 : paths[0][c - 1]
      end

      # First column
      (1...m).each do |r|
        paths[r][0] = obstacle_grid[r][0] == 1 ? 0 : paths[r - 1][0]
      end

      # Fill rest
      (1...m).each do |r|
        (1...n).each do |c|
          if obstacle_grid[r][c] == 1
            paths[r][c] = 0
          else
            paths[r][c] = paths[r - 1][c] + paths[r][c - 1]
          end
        end
      end

      paths[m - 1][n - 1]
    end

    # Tabulation (bottom-up) - 1D optimized
    #
    # dp[c]: number of paths to current row at column c
    #
    # Update:
    #   if obstacle => dp[c] = 0
    #   else dp[c] = dp[c] (from above) + dp[c-1] (from left)
    #
    # Time:  O(m*n)
    # Space: O(n)
    def tabulation_1d(obstacle_grid)
      validate_grid!(obstacle_grid)

      m = obstacle_grid.size
      n = obstacle_grid[0].size

      dp = Array.new(n, 0)
      dp[0] = obstacle_grid[0][0] == 1 ? 0 : 1

      (0...m).each do |r|
        (0...n).each do |c|
          if obstacle_grid[r][c] == 1
            dp[c] = 0
          else
            next if r == 0 && c == 0
            from_left  = (c > 0) ? dp[c - 1] : 0
            from_above = dp[c]
            dp[c] = from_left + from_above
          end
        end
      end

      dp[n - 1]
    end

    private

    # dp(r, c): number of paths from start to (r,c) (0-based)
    def dp(r, c)
      return 0 if r < 0 || c < 0
      return 0 if @grid[r][c] == 1
      return 1 if r == 0 && c == 0

      cached = @memo[r][c]
      return cached unless cached.nil?

      @memo[r][c] = dp(r - 1, c) + dp(r, c - 1)
    end

    def validate_grid!(grid)
      raise ArgumentError, "obstacle_grid must be an Array" unless grid.is_a?(Array)
      raise ArgumentError, "obstacle_grid must not be empty" if grid.empty?
      raise ArgumentError, "obstacle_grid rows must be Arrays" unless grid.all? { |row| row.is_a?(Array) }
      raise ArgumentError, "obstacle_grid must be rectangular" unless grid.map(&:size).uniq.size == 1

      n = grid[0].size
      raise ArgumentError, "obstacle_grid must have at least 1 column" if n == 0

      unless grid.flatten.all? { |x| x.is_a?(Integer) && (x == 0 || x == 1) }
        raise ArgumentError, "obstacle_grid values must be 0 or 1"
      end
    end
  end
end