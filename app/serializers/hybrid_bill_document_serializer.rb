class HybridBillDocumentSerializer
  def self.serialize(petition_id, document_object)
    file_content = File.binread(document_object.file.tempfile)
    document_data = Base64.encode64(file_content)

    {
      'ReferenceNumber': petition_id,
      'Filename': document_object.filename,
      'DocumentData': document_data
    }.to_json
  end
end
