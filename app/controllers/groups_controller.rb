class GroupsController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.group_by_id.set_url_params({ group_id: params[:group_id] }) }
  }.freeze

  def show
  	@group, @house, @formal_body_type, @person, @party, @constituency, @postal_address = Parliament::Utils::Helpers::FilterHelper.filter(@request, 'Group', 'House', 'FormalBodyType', 'Person', 'Party', 'ConstituencyGroup', 'PostalAddress')

  	@group = @group.first

  	@house = @house.first

  	@formal_body_type = @formal_body_type.first

  	@person = @person.first

  	@party = @party.first

  	@constituency = @constituency.first

  	@postal_address = @postal_address.first
  end
end
