class HybridBillTermsSerializer
  def self.serialize(petition_id)
    {
      'ReferenceNumber':petition_id
    }.to_json
  end
end
