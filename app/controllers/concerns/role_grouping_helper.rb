class RoleGroupingHelper
  extend GroupingHelper
  # Finds Grom::Nodes that can be grouped and builds GroupingHelper::GroupedObject objects
  #
  # @return start_date [DateTime] Earliest start date
  # @return end_date [DateTime] Latest end date
  # @return nodes [Array] Array of Grom::Nodes
  # @return type [String] Type of all grouped Grom::Nodes
  class RoleGroupedObject
    attr_accessor :start_date, :end_date, :nodes, :type
  end

  # Creates new GroupingHelper::GroupedObject, for each set of Grom::Nodes that have been grouped (nodes)
  # Each instance of GroupingHelper::GroupedObject is assigned properties of start_date, end_date, nodes and type
  # Once object has been created, calls sort_grouped_nodes_by_date method to sort that object's nodes by date
  #
  # @param data_hash [Hash] Keys identify grouping, with each value being an array of grouped, ungrouped and unknown Grom::Nodes
  # @param key [String] Key identifies grouping of Grom::Nodes
  # @return [Array] with instances of GroupingHelper::GroupedObject
  def self.create_grouped_objects(data_hash, key)
    grouped = []

    grouped_object = RoleGroupingHelper::RoleGroupedObject.new
    grouped_object.nodes = data_hash[key]

    start_date = nil
    end_date = nil
    current_nodes = []

    grouped_object.nodes.each do |node|
      # Find nodes that represents current roles
      current_nodes << node if node.try(:end_date).nil? || node.end_date.nil?
      # Find earliest start date and latest end date
      start_date = node.start_date if start_date.nil? || node.start_date < start_date
      end_date = node.end_date if current_nodes.empty? && (end_date.nil? || node.end_date > end_date)
    end

    # Set properties of the object
    # TODO: Might need to adjust to allow for multiple roles roles and memberships of a committee
    grouped_object.type = grouped_object.nodes.first.type
    grouped_object.start_date = start_date
    grouped_object.end_date = current_nodes.empty? ? end_date : nil

    # Add sorted object to the array
    sort_grouped_nodes_by_date(grouped_object, current_nodes)
    grouped << grouped_object
  end

  # Sorts an array of grouped Grom::Nodes by end date, placing the most current Grom::Node at the start of the array
  #
  # @param grouped_object [Instance object] Instance of GroupingHelper::GroupedObject
  # @param current_node [Grom::Node] Grom::Node with no end date (representing current)
  # @return [Instance object] Returns the same instance, with nodes sorted by end date
  def self.sort_grouped_nodes_by_date(grouped_object, current_nodes)
    grouped_object.nodes -= current_nodes unless current_nodes.empty?
    grouped_object.nodes.sort_by!(&:end_date).reverse!
    grouped_object.nodes.unshift(current_nodes).flatten! unless current_nodes.empty?
  end
end
