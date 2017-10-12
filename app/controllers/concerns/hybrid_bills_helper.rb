
module HybridBillsHelper

	module API
		PETITION_URL = ENV['HYBRID_BILLS_PETITION_URL']
		PETITION_DOCUMENT_URL = ENV['HYBRID_BILLS_PETITION_DOCUMENT_URL']
		HYBRID_BILLS_TOKEN = ENV['HYBRID_TOKEN']
		#TEST = ENV['TEST']
	end

	class HybridBillsSessionStore

		def initialize(params, session)
			set('type', params[:type], session)
			set('accept', params[:accept], session)
			set('FirstName', params[:FirstName], session)
			set('Surname', params[:Surname], session)
			set('Title', params[:Title], session)
			set('JobTitle', params[:JobTitle], session)
			set('AddressLine1', params[:AddressLine1], session)
			set('AddressLine2', params[:AddressLine2], session)
        end

  #session is now a constant and is available within context of helper as helper is available from within controller 
  #SESSION should be available as env variable. To confirm
        def get(key, session)
            new_symbol = key.to_sym
            return session[new_symbol]
        end

        def set(key, value, session)
        	new_symbol = key.to_sym
        	session[new_symbol] = value if value
        end
	end	

	# class HybridBillsPetitionSubmission 
 #    end		
end