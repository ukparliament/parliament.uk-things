class ProceduresController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.procedure_by_id.set_url_params({ procedure_id: params[:procedure_id] }) }
  }.freeze

  # @return [Grom::Node] object with type 'https://id.parliament.uk/schema/Procedure'.

  def show
    @procedure = Parliament::Utils::Helpers::FilterHelper.filter(
      @request,
      'Procedure'
    )

    @procedure = @procedure.first
    @work_packageable_things = @procedure.work_packages.map(&:work_packageable_thing)

    @work_packageable_things = Parliament::NTriple::Utils.multi_direction_sort({
      list: @work_packageable_things,
      parameters: { oldest_business_item_date: :desc, name: :asc },
      prepend_rejected: false
    })

  end
end
