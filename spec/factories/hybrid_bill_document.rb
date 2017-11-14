FactoryBot.define do
  factory :hybrid_bill_document do
    file Rack::Test::UploadedFile.new(File.new("#{Rails.root}/spec/fixtures/files/test_doc.doc"))
    initialize_with { new({ file: file }) }

    factory :hybrid_bill_document_with_invalid_file do
      file Rack::Test::UploadedFile.new(File.new("#{Rails.root}/spec/fixtures/files/test_doc.tif"))
    end
  end
end
