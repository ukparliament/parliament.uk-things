class HybridBillTermsSerializer
  def self.serialize(petition_id, terms)
    {
      'HybridBillPetitionId':petition_id,
      'TermsAndConditionsAccepted':terms
    }.to_json
  end
end
