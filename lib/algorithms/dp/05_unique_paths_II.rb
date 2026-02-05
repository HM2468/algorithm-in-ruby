# frozen_string_literal: true

=begin
63. Unique Paths II

You are given an m x n grid with obstacles.
A robot starts at top-left (0,0) and wants to reach bottom-right (m-1,n-1).
The robot can only move DOWN or RIGHT.
An obstacle is marked as 1; free cell is 0.
Return the number of unique paths.

Conventions (strictly 0-based):
  - m: number of rows
  - n: number of columns
  - grid[row][col]
  - Start:  (0, 0)
  - Finish: (m-1, n-1)

@param obstacle_grid [Array<Array<Integer>>]
@return [Integer]

DP model (classic with obstacles):
  If obstacle_grid[r][c] == 1 => paths[r][c] = 0
  Else paths[r][c] = paths[r-1][c] + paths[r][c-1]

Base:
  If start is obstacle => 0
  First row/col must stop propagating 1s once an obstacle is hit.
=end

module DP
  class UniquePathsII
    # Memoization (top-down)
    #
    # dp(r, c): number of paths from (0,0) to (r,c)
    #
    # Time:  O(m*n)
    # Space: O(m*n) memo + recursion stack O(m+n)
    def memoization_unique_paths_with_obstacles(obstacle_grid)
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
    def tabulation_unique_paths_with_obstacles(obstacle_grid)
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
    def tabulation_unique_paths_with_obstacles_1d(obstacle_grid)
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