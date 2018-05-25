class BusinessItemGroupingHelper
  extend GroupingHelper
  # Finds Grom::Nodes that can be grouped and builds BusinessItemGroupingHelper::BusinessItemGroupedObject objects
  #
  # @return date [DateTime] Date of all Grom::Nodes
  # @return nodes [Array] Array of Grom::Nodes
  # @return type [String] Type of all grouped Grom::Nodes
  class BusinessItemGroupedObject
    attr_accessor :date, :nodes, :type
  end

  # Creates new BusinessItemGroupingHelper::BusinessItemGroupedObject, for each set of Grom::Nodes that have been grouped (nodes) and unknown
  # Each instance of BusinessItemGroupingHelper::BusinessItemGroupedObject is assigned properties of laying_date, nodes and type
  #
  # @param data_hash [Hash] Keys identify grouping, with each value being an array of grouped, ungrouped and unknown Grom::Nodes
  # @param key [String] Key identifies grouping of Grom::Nodes
  # @return [Array] with instances of GroupingHelper::GroupedObject
  def self.create_grouped_objects(data_hash, key)
    grouped = []

    grouped_object = BusinessItemGroupingHelper::BusinessItemGroupedObject.new
    grouped_object.nodes = data_hash[key].sort_by(&:shortest_distance_of_procedure_steps)

    # Set properties of the object
    grouped_object.type = grouped_object.nodes.first.type
    grouped_object.date = grouped_object.nodes.first.date
    grouped << grouped_object
  end
end
