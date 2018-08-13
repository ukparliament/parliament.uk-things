class ProceduresController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show: proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.procedure_by_id.set_url_params({ procedure_id: params[:procedure_id] }) }
  }.freeze

  def show
    @procedure, @work_packages = Parliament::Utils::Helpers::FilterHelper.filter(
      @request,
      'Procedure',
      'WorkPackage'
    )

    @procedure = @procedure.first

    @work_packages = Parliament::NTriple::Utils.multi_direction_sort({
      list: @work_packages.nodes,
      parameters: { oldest_business_item_date: :desc, work_packageable_thing_name: :asc },
      prepend_rejected: false
    })

  end
end
