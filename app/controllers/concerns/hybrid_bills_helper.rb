module HybridBillsHelper

  HybridBillPetitionAgent, HybridBillPetitioner = {}, {}
  
  SESSION_SEPARATOR = 'hybrid_bills_submission'
  SESSION_KEYS = %W(CommitteeBusinessId accept HyBridBillPetitionId DocumentData isConfidential) 
  SESSION_KEYS_PETITIONER = %W(HybridBillPetitioner[SubmitterType] HybridBillPetitioner[OrganisationName] HybridBillPetitioner[FirstName] HybridBillPetitioner[Surname] HybridBillPetitioner[Title] HybridBillPetitioner[JobTitle] HybridBillPetitioner[AddressLine1] HybridBillPetitioner[AddressLine2] HybridBillPetitioner[Town] HybridBillPetitioner[County] HybridBillPetitioner[Country] HybridBillPetitioner[Postcode] HybridBillPetitioner[Email] HybridBillPetitioner[Telephone] HybridBillPetitioner[ShouldBeContacted]) 
  SESSION_KEYS_AGENT = %W(HybridBillPetitionAgent[ShouldBeContacted] HybridBillPetitionAgent[AgentType] HybridBillPetitionAgent[FirstName] HybridBillPetitionAgent[Surname] HybridBillPetitionAgent[Title] HybridBillPetitionAgent[JobTitle] HybridBillPetitionAgent[AddressLine1] HybridBillPetitionAgent[Town] HybridBillPetitionAgent[County] HybridBillPetitionAgent[Country] HybridBillPetitionAgent[Postcode] HybridBillPetitionAgent[Email] HybridBillPetitionAgent[Telephone] HybridBillPetitionAgent[Telephone])

  SESSION_KEYS.concat(SESSION_KEYS_PETITIONER, SESSION_KEYS_AGENT)

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
