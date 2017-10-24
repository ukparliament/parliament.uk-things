class HybridBillSubmissionSerializer
  def self.serialize(committee_business_id:, petitioner_object:, agent_object: nil)
    json_object = {
      'CommitteeBusinessId': committee_business_id
    }

    json_object['HybridBillPetitioner'] = {
      'SubmitterType':      petitioner_object.submitter_type,
      'OnBehalfOf':         petitioner_object.on_behalf_of,
      'FirstName':          petitioner_object.first_name,
      'Surname':            petitioner_object.surname,
      'AddressLine1':       petitioner_object.address_1,
      'AddressLine2':       petitioner_object.address_2,
      'Country':            petitioner_object.country,
      'Postcode':           petitioner_object.postcode,
      'Email':              petitioner_object.email,
      'Telephone':          petitioner_object.telephone,
      'ShouldBeContacted':  petitioner_object.should_be_contacted
    }

    if agent_object
      json_object['HybridBillPetitionAgent'] = {
        'FirstName':          agent_object.first_name,
        'Surname':            agent_object.surname,
        'AddressLine1':       agent_object.address_1,
        'AddressLine2':       agent_object.address_2,
        'Country':            agent_object.country,
        'Postcode':           agent_object.postcode,
        'Email':              agent_object.email,
        'Telephone':          agent_object.telephone,
        'ReceivesUpdates':    agent_object.receives_updates
      }
    end

    json_object.to_json
  end
end
