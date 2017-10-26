class HybridBillDocumentSerializer
  def self.serialize(petition_id, filename, file)
    file_content = File.binread(file)
    document_data = Base64.encode64(file_content)

    {
      'ReferenceNumber': petition_id,
      'Filename': filename,
      'DocumentData': document_data
    }.to_json
  end
end
