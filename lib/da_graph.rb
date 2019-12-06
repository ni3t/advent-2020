# directed acyclic graph
class DAGraph
  attr_accessor :root, :nodes, :edges
  
  def initialize(root = nil)
    @root = root
    @nodes = []
    @edges = []
  end
 
  def add_node_safe(name, value)
    node = find_node_by_name(name)
    unless node
      node = DANode.new(self, name, value)
      nodes << node
    end
    node
  end

  def add_edge_safe(node1, node2)
    edge = find_edge_by_nodes(node1, node2)
    unless edge
      edge = DAEdge.new(self, node1, node2)
      edges << edge
      node1.edges << edge
      node2.edges << edge
    end
    edge
  end

  def find_node_by_name(name)
    nodes.find { |node| node.name == name }
  end

  def find_edge_by_nodes(node1, node2)
    edge = edges.find { |e| e.nodes == [node1, node2] }
  end
end

class DANode
  attr_accessor :graph, :name, :value, :edges
  
  def initialize(graph, name, value)
    @graph = graph
    @name = name
    @value = value
    @edges = []
  end

  def neighbors
    (parent + children)
  end

  def parent
    edges.find { |edge| edge.nodes.last == self }&.nodes&.first
  end

  def children
    edges.filter { |edge| edge.nodes.first == self }.map(&:nodes).flatten - [self]
  end

  def ancestors
    parent ? parent.ancestors.push(parent) : []
  end

  def add_child_safe(node)
    graph.add_edge_safe(self, node)
  end

  def distance_to(node)
    if ancestors.include?(node)
      depth - node.depth
    else
      path_to(node).size
    end
  end

  def depth
    ancestors.size
  end

  def path_to(node)
    [
      (node.ancestors - ancestors),
      common_parent(node),
      (ancestors - node.ancestors)
    ].flatten
  end

  def common_parent(node)
    (ancestors & node.ancestors).last
  end
end

class DAEdge
  attr_accessor :graph, :nodes
  
  def initialize(graph, *nodes)
    @graph = graph
    @nodes = nodes
  end
end