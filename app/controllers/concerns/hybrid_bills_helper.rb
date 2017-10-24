module HybridBillsHelper
  def self.api_request
    Parliament::Request::UrlRequest.new(ENV['HYBRID_BILL_API_BASE_URL'], headers: { 'CMS-Token' => ENV['HYBRID_BILL_API_TOKEN'] }, builder: Parliament::Builder::BaseResponseBuilder)
  end
end
