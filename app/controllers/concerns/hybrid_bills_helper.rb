module HybridBillsHelper
  SESSION_SEPARATOR = 'hybrid_bills_submission'
  SESSION_KEYS = %W(type accept FirstName Surname Title JobTitle AddressLine1 AddressLine2)

  def create_session
    session[SESSION_SEPARATOR] = {} if session[SESSION_SEPARATOR].nil?

    SESSION_KEYS.each do |key|
      set_hybrid_bills_session_value(key, params[key.to_sym])
    end
  end

  #session is now a constant and is available within context of helper as helper is available from within controller
  #SESSION should be available as env variable. To confirm
  def get_hybrid_bills_session_value(key)
    return session[SESSION_SEPARATOR][key]
  end

  def set_hybrid_bills_session_value(key, value)
    session[SESSION_SEPARATOR][key] = value if value
  end

  def reset_hybrid_bills_session
    SESSION_KEYS.each do |key|
      session.delete(key.to_sym)
    end
  end

	module API
		PETITION_URL = ENV['HYBRID_BILLS_PETITION_URL']
		PETITION_DOCUMENT_URL = ENV['HYBRID_BILLS_PETITION_DOCUMENT_URL']
		HYBRID_BILLS_TOKEN = ENV['HYBRID_TOKEN']
	end
end
