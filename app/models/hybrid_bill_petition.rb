class HybridBillPetition 

	include ActiveModel::Validations

	attr_accessor :document_data, :filename, :petition_id

	validates_with HybridBillPetitionValidator

    #regex filetypes .doc,.docx, .rtf, .txt, .ooxml, .odt, .pdf
	DOCUMENT_REGEX = /.(docx|txt|ooxml|rtf|pdf|doc)$\z/

	validates :document_data, :presence => { :message => "Document must be uploaded" }
	validates :filename, format: { with: DOCUMENT_REGEX, message: "File type is invalid" }
	validates :petition_id, presence: true, allow_blank: true

end
