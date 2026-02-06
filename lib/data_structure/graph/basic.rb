module DataStructure
  module Graph
    class Graph
      attr_reader :n, :adj

      def initialize(n)
        @n = n
        # 每个顶点一条邻接数组
        @adj = Array.new(n) { [] }
      end

      # 无权图：只存终点 v
      def add_edge(u, v, directed: false)
        @adj[u] << v
        @adj[v] << u unless directed
      end
    end


    class WeightedGraph
      attr_reader :n, :adj

      def initialize(n)
        @n = n
        # 每个顶点一条邻接数组，元素是 [to, weight]
        @adj = Array.new(n) { [] }
      end

      def add_edge(u, v, w, directed: false)
        @adj[u] << [v, w]
        @adj[v] << [u, w] unless directed
      end
    end
  end
end