class PartiesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index:             proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_index },
    show:              proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_by_id.set_url_params({ party_id: params[:party_id] }) },
    lookup:            proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_lookup.set_url_params({ property: params[:source], value: params[:id] }) },
    current:           proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_current },
    letters:           proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_by_initial.set_url_params({ initial: params[:letter] }) },
    a_to_z:            proc { Parliament::Utils::Helpers::ParliamentHelper.parliament_request.party_a_to_z },

    # NOT IN THE ORIGINAL ROUTE MAP BUT IN NEW DATA API URL STRUCTURE??
    # current_a_to_z:      proc { ParliamentHelper.parliament_request.party_current_a_to_z }
  }.freeze

  def show
    @party = @request.get.first
  end

  def lookup
    @party = @request.get.first

    redirect_to party_path(@party.graph_id)
  end
end
