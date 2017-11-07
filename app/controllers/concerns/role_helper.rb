# Namespace for role helper methods
module RoleHelper
  # Return role type as string
  # @param [String] URI string that represents the schema type of an object
  # @example "https://id.parliament.uk/schema/GovernmentIncumbency" returns "GovernmentIncumbency"
  def self.role_type(role, role_type)
    Grom::Helper.get_id(role.type) == role_type
  end
end
