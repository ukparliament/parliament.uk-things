module HybridBillsHelper
  def self.api_request
    Parliament::Request::UrlRequest.new(
      base_url: ENV['HYBRID_BILL_API_BASE_URL'],
      headers:  {
        'CMS-Token':    ENV['HYBRID_BILL_API_TOKEN'],
        'Content-Type': 'application/json',
        'Accept':       'application/json'
      },
      builder:  Parliament::Builder::BaseResponseBuilder
    )
  end

  def self.process_request(request, request_json, step)
    # How long will we wait before timing out a post request
    post_timeout = 10

    begin
      response = request.post(body: request_json, timeout: post_timeout)
    rescue Parliament::ClientError, Parliament::ServerError, Net::ReadTimeout => e
      # Something went wrong at AMS level
      Airbrake.notify(e)

      Rails.logger.error("HybridBill #{step} - post returned a non-200 status")
      Rails.logger.error(e)

      fail e
    end

    Rails.logger.info "HybridBill #{step} - received #{response.response.code}: #{response.response.body}"

    begin
      json_response = JSON.parse(response.response.body)
    rescue JSON::ParserError => e
      Airbrake.notify(e)

      Rails.logger.error("HybridBill #{step} - JSON parsing failed")
      Rails.logger.error(e)

      fail e
    end

    if json_response['StatusCode'] != 200 || json_response['Success'] != true
      exception = HybridBillsHelper::HybridBillError.new(json_response['StatusCode'], json_response['Success'], response.response.body)

      Airbrake.notify(exception)

      Rails.logger.error("HybridBill #{step} - Unexpected response from Business Systems API")
      Rails.logger.error(exception)

      fail exception
    end

    json_response
  end

  class HybridBillError < StandardError
    def initialize(status_code, success, response)
      error_string = <<~ERROR
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
