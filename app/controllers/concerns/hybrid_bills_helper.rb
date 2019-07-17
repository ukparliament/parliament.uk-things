module HybridBillsHelper
  def self.api_request
    HybridBillRequest.new(
      base_url: 'https://services-externalsubmissions.parliament.uk',
      headers:  {
        'CMS-Token':    'a88073f5-3df2-46d6-8bd2-7f38a0731af0',
        'Content-Type': 'application/json',
        'Accept':       'application/json'
      },
      builder:  Parliament::Builder::BaseResponseBuilder
    )
  end

  def self.process_request(request, request_json, step, endpoint)
    # How long will we wait before timing out a post request
    post_timeout = 10

    begin
      response = request.post(body: request_json, endpoint: endpoint)
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

  class HybridBillRequest
    attr_reader :base_url, :headers, :query_params
    # Creates a new instance of Parliament::Request::BaseRequest.
    #
    # An interesting note for #initialize is that setting base_url on the class, or using the environment variable
    # PARLIAMENT_BASE_URL means you don't need to pass in a base_url. You can pass one anyway to override the
    # environment variable or class parameter.  Similarly, headers can be set by either settings the headers on the class, or passing headers in.
    #
    # @example Setting the base_url on the class
    #   Parliament::Request::BaseRequest.base_url = 'http://example.com'
    #
    #   Parliament::Request::BaseRequest.new.base_url #=> 'http://example.com'
    #
    # @example Setting the base_url via environment variable
    #   ENV['PARLIAMENT_BASE_URL'] #=> 'http://test.com'
    #
    #   Parliament::Request::BaseRequest.new.base_url #=> 'http://test.com'
    #
    # @example Setting the base_url via a parameter
    #   Parliament::Request::BaseRequest.base_url #=> nil
    #   ENV['PARLIAMENT_BASE_URL'] #=> nil
    #
    #   Parliament::Request::BaseRequest.new(base_url: 'http://example.com').base_url #=> 'http://example.com'
    #
    # @example Overriding the base_url via a parameter
    #   ENV['PARLIAMENT_BASE_URL'] #=> 'http://test.com'
    #
    #   Parliament::Request::BaseRequest.new(base_url: 'http://example.com').base_url #=> 'http://example.com'
    #
    # @example Setting the headers on the class
    #   Parliament::Request::BaseRequest.headers = { 'Accept' => 'Test' }
    #
    #   Parliament::Request::BaseRequest.new.headers #=> '{ 'Accept' => 'Test' }
    #
    # @example Setting the headers via a parameter
    #   Parliament::Request::BaseRequest.headers #=> nil
    #
    #   Parliament::Request::BaseRequest.new(headers: '{ 'Accept' => 'Test' }).headers #=> { 'Accept' => 'Test' }
    #
    # @example Overriding the headers via a parameter
    #   Parliament::Request::BaseRequest.headers = { 'Accept' => 'Test' }
    #
    #   Parliament::Request::BaseRequest.new(headers: '{ 'Accept' => 'Test2' }).headers #=> { 'Accept' => 'Test2' }
    #
    # @param [String] base_url the base url of our api. (expected: http://example.com - without the trailing slash).
    # @param [Hash] headers the headers being sent in the request.
    # @param [Parliament::Builder] builder the builder to use in order to build a response.
    # @params [Module] decorators the decorator module to use in order to provide possible alias methods for any objects created by the builder.
    def initialize(base_url: nil, headers: nil, builder: nil, decorators: nil)
      @base_url = base_url || self.class.base_url
      @headers = headers || self.class.headers || {}
      @builder = builder || Parliament::Builder::BaseResponseBuilder
      @decorators = decorators
      @query_params = {}
    end


    # Makes an HTTP GET request and process results into a response.
    #
    # @example HTTP GET request
    #   request = Parliament::Request::BaseRequest.new(base_url: 'http://example.com/people/123'
    #
    #   # url: http://example.com/people/123
    #
    #   response = request.get #=> #<Parliament::Response::BaseResponse ...>
    #
    # @example HTTP GET request with URI encoded form values
    #   request = Parliament::Request.new(base_url: 'http://example.com/people/current')
    #
    #   # url: http://example.com/people/current?limit=10&page=4&lang=en-gb
    #
    #   response = request.get({ limit: 10, page: 4, lang: 'en-gb' }) #=> #<Parliament::Response::BaseResponse ...>
    #
    # @raise [Parliament::ServerError] when the server responds with a 5xx status code.
    # @raise [Parliament::ClientError] when the server responds with a 4xx status code.
    # @raise [Parliament::NoContentResponseError] when the response body is empty.
    #
    # @param [Hash] params (optional) additional URI encoded form values to be added to the URI.
    #
    # @return [Parliament::Response::BaseResponse] a Parliament::Response::BaseResponse object containing all of the data returned from the URL.
    def get(params: nil)
      @query_params = @query_params.merge(params) unless params.nil?

      endpoint_uri = URI.parse(query_url)
      endpoint_uri.query = URI.encode_www_form(@query_params.to_a) unless @query_params.empty?

      http = Net::HTTP.new(endpoint_uri.host, endpoint_uri.port)
      http.use_ssl = true if endpoint_uri.scheme == 'https'

      net_response = http.start do |h|
        api_request = Net::HTTP::Get.new(endpoint_uri.request_uri)
        add_headers(api_request)

        h.request api_request
      end

      handle_errors(net_response)

      build_response(net_response)
    end

    # Makes an HTTP POST request and process results into a response.
    #
    # @example HTTP POST request
    #   request = Parliament::Request::BaseRequest.new(base_url: 'http://example.com/people/123', headers: {'Content': 'application/json', 'Accept': 'application/json'})
    #
    #   # url: http://example.com/people/123
    #
    #   response = request.post(body: {}.to_json) #=> #<Parliament::Response::BaseResponse ...>
    #
    # @example HTTP POST request with URI encoded form values
    #   request = Parliament::Request::BaseRequest.new(base_url: 'http://example.com/people/current', headers: {'Content': 'application/json', 'Accept': 'application/json'})
    #
    #   # url: http://example.com/people/current?limit=10&page=4&lang=en-gb
    #
    #   response = request.post({ limit: 10, page: 4, lang: 'en-gb' }, body: {}.to_json) #=> #<Parliament::Response::BaseResponse ...>
    #
    # @raise [Parliament::ServerError] when the server responds with a 5xx status code.
    # @raise [Parliament::ClientError] when the server responds with a 4xx status code.
    # @raise [Parliament::NoContentResponseError] when the response body is empty.
    #
    # @param [Hash] params (optional) additional URI encoded form values to be added to the URI.
    # @param [String] body (optional) body of the post request.
    #
    # @return [Parliament::Response::BaseResponse] a Parliament::Response::BaseResponse object containing all of the data returned from the URL.
    def post(params: nil, body: nil, endpoint: nil)
      @query_params = @query_params.merge(params) unless params.nil?

      endpoint_uri = URI.parse(@base_url + '/' + endpoint)
      endpoint_uri.query = URI.encode_www_form(@query_params.to_a) unless @query_params.empty?

      http = Net::HTTP.new(endpoint_uri.host, endpoint_uri.port)
      http.use_ssl = true if endpoint_uri.scheme == 'https'

      net_response = http.start do |h|
        api_request = Net::HTTP::Post.new(endpoint_uri.request_uri)
        add_headers(api_request)
        api_request.body = body unless body.nil?

        h.request api_request
      end

      handle_errors(net_response)

      build_response(net_response)
    end

    private

    # @attr [String] base_url the base url of our api. (expected: http://example.com - without the trailing slash).
    # @attr [Hash] headers the headers being sent in the request.
    class << self
      attr_accessor :base_url, :headers
    end

    def build_response(net_response)
      @builder.new(response: net_response, decorators: @decorators).build
    end

    def query_url
      @base_url
    end

    def default_headers
      { 'Accept' => 'application/n-triples' }
    end

    def add_headers(request)
      headers = default_headers.merge(@headers)
      headers.each do |key, value|
        request.add_field(key, value)
      end
    end

    def handle_errors(net_response)
      case net_response
      when Net::HTTPOK # 2xx Status
        exception_class = Parliament::NoContentResponseError if net_response['Content-Length'] == '0'
      when Net::HTTPClientError # 4xx Status
        exception_class = Parliament::ClientError
      when Net::HTTPServerError # 5xx Status
        exception_class = Parliament::ServerError
      end

      raise exception_class.new(query_url, net_response) if exception_class
    end
  end
end
