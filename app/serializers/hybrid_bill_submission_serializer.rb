class HybridBillSubmissionSerializer
  def self.serialize(committee_business_id, petitioner_object)
    json_object = {
      'CommitteeBusinessId': committee_business_id
    }

    petitioner_country = petitioner_object.in_the_uk == 'true' ? 'GB' : petitioner_object.country
    petitioner_updates = (petitioner_object.receive_updates == '1')

    json_object['HybridBillPetitioner'] = {
      'SubmitterType':   petitioner_object.submitter_type,
      'OnBehalfOf':      petitioner_object.on_behalf_of,
      'FirstName':       petitioner_object.first_name,
      'Surname':         petitioner_object.surname,
      'AddressLine1':    petitioner_object.address_1,
      'AddressLine2':    petitioner_object.address_2,
      'Country':         petitioner_country,
      'Postcode':        petitioner_object.postcode,
      'Email':           petitioner_object.email,
      'Telephone':       petitioner_object.telephone,
      'ReceivesUpdates': petitioner_updates
    }

    if petitioner_object.has_a_rep == 'true'
      agent_country = petitioner_object.hybrid_bill_agent.in_the_uk == 'true' ? 'GB' : petitioner_object.hybrid_bill_agent.country
      agent_updates = (petitioner_object.hybrid_bill_agent.receive_updates == '1')

      json_object['HybridBillPetitionAgent'] = {
        'FirstName':       petitioner_object.hybrid_bill_agent.first_name,
        'Surname':         petitioner_object.hybrid_bill_agent.surname,
        'AddressLine1':    petitioner_object.hybrid_bill_agent.address_1,
        'AddressLine2':    petitioner_object.hybrid_bill_agent.address_2,
        'Country':         agent_country,
        'Postcode':        petitioner_object.hybrid_bill_agent.postcode,
        'Email':           petitioner_object.hybrid_bill_agent.email,
        'Telephone':       petitioner_object.hybrid_bill_agent.telephone,
        'ReceivesUpdates': agent_updates
      }
    end

    json_object.to_json
  end
end
