class ContactPointsController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show:  proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.contact_point_by_id.set_url_params({ contact_point_id: params[:contact_point_id] }) }
  }.freeze

  def show
    @contact_point = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      Parliament::Utils::Helpers::RequestHelper.namespace_uri_schema_path('ContactPoint')
    ).first

    vcard = create_vcard(@contact_point)
    send_data vcard.to_s, filename: 'contact.vcf', disposition: 'attachment', data: { turbolink: false }
  end
end
