module HybridBillsHelper
  def self.api_request
    Parliament::Request::UrlRequest.new(base_url: ENV['HYBRID_BILL_API_BASE_URL'], headers: { 'CMS-Token': ENV['HYBRID_BILL_API_TOKEN'], 'Content-Type': 'application/json', 'Accept': 'application/json' }, builder: Parliament::Builder::BaseResponseBuilder)
  end

  def self.process_request(request, request_json, step, show_error_page:false)
    begin
      response = request.post(body: request_json)
    rescue Parliament::ClientError, Parliament::ServerError => e
      # Something went wrong at AMS level
      Airbrake.notify(e)

      logger.error("HybridBill #{step} - post returned a non-200 status")
      logger.error(e)

      return handle_error(show_error_page)
    end

    logger.info "HybridBill #{step} - received #{response.response.code}: #{response.response.body}"

    begin
      json_response = JSON.parse(response.response.body)
    rescue JSON::ParserError => e
      Airbrake.notify(e)

      logger.error("HybridBill #{step} - JSON parsing failed")
      logger.error(e)

      return handle_error(show_error_page)
    end

    if json_response['Status'] != '200' || json_response['Success'] != true
      exception = HybridBillsHelper::HybridBillError.new(json_response['Status'], json_response['Success'], response.response.body)

      Airbrake.notify(exception)

      logger.error("HybridBill #{step} - Unexpected response from Business Systems API")
      logger.error(exception)

      return handle_error(show_error_page)
    end

    json_response
  end

  def handle_error(show_error)
    return render 'hybrid_bills/errors/submit_another_way' if show_error

    redirect_to hybrid_bill_path(params[:bill_id]), alert: '.something_went_wrong'
  end

  class HybridBillError < StandardError
    def initialize(status_code, success, response)
      error_string = <<ERROR
HybridBillError - An unsuccessful response has been recieved from the Business Systems API:
Status (expected 200) - (got #{status_code})
Success (expected true) - (get #{success})

Response Body:
#{response}
ERROR

      super(error_string)
    end
  end
end
