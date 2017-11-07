module HybridBillsHelper
  def self.api_request
    Parliament::Request::UrlRequest.new(base_url: ENV['HYBRID_BILL_API_BASE_URL'], headers: { 'CMS-Token': ENV['HYBRID_BILL_API_TOKEN'], 'Content-Type': 'application/json', 'Accept': 'application/json' }, builder: Parliament::Builder::BaseResponseBuilder)
  end
end
