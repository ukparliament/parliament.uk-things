class PartiesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show:              proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parties(params[:party_id]) },
    lookup:            proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.parties.lookup(params[:source], params[:id]) }
  }.freeze

  def show
    @party = @request.get.first
  end

  def lookup
    @party = @request.get.first

    redirect_to party_path(@party.graph_id)
  end
end
