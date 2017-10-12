module HybridBillsHelper
	module API
		PETITION_URL = ENV['HYBRID_BILLS_PETITION_URL']
		PETITION_DOCUMENT_URL = ENV['HYBRID_BILLS_PETITION_DOCUMENT_URL']
		HYBRID_BILLS_TOKEN = ENV['HYBRID_TOKEN']
		TEST = ENV['TEST']
	end

	class HybridBillsSessionStore

		def initialize(params)
			SESSION[:accept] = params[:sccept] if params[:accept]


        
        end 
	end	

	# def self.get_response(url)
	# 	Net::HTTP.get(URI(url))
 #    end
end	

#Parliament::BaseRequest.get(HybridBillsHelper::API::PETITION_URL)