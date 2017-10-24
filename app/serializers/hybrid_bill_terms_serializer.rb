class HybridBillTermsSerializer
  def self.serialize(petition_id, terms)
    {
      'HybridBillPetitionId':petition_id,
      'AcceptedTerms':terms
    }.to_json
  end
end
