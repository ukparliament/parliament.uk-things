class GroupsController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.group_by_id.set_url_params({ group_id: params[:group_id] }) }
  }.freeze

  def show
  	@group, @contact_points, @postal_address = Parliament::Utils::Helpers::FilterHelper.filter(
      @request,
      'Group',
      'ContactPoint',
      'PostalAddress'
    )

  	@group = @group.first
    @postal_address = @postal_address.first
    @chair_people = @group.chair_people if @group.formal_body?
  end
end
