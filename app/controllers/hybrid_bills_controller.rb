class HybridBillsController < ApplicationController
  before_action :disable_top_navigation, :disable_status_banner
  before_action :validate_business_id, only: :show
  before_action :create_hybrid_bill_submission, only: :show

  STEP_TEMPLATES = {
    'send-a-petition':                        'hybrid_bills/steps/send-a-petition',
    'writing-your-petition':                  'hybrid_bills/steps/writing-your-petition',
    'who-are-you-submitting-a-petition-for':  'hybrid_bills/steps/who-are-you-submitting-a-petition-for',
    'details': {
      'individual':         'hybrid_bills/steps/forms/individual',
      'individualgroup':    'hybrid_bills/steps/forms/individualgroup',
      'organisation':       'hybrid_bills/steps/forms/organisation',
      'organisationgroup':  'hybrid_bills/steps/forms/organisationgroup'
    },
    'document-submission':  'hybrid_bills/steps/document-submission',
    'terms-conditions':     'hybrid_bills/steps/terms-conditions',
    'complete':             'hybrid_bills/steps/confirm'
  }

  SUBMISSION_TYPES = {
    'individual':         HybridBillIndividualSubmission,
    'individualgroup':    HybridBillIndividualGroupSubmission,
    'organisation':       HybridBillOrganisationSubmission,
    'organisationgroup':  HybridBillOrganisationGroupSubmission
  }

  def index
  end

  def show
  	@business_id = params[:bill_id]

    if params[:step]
      template = STEP_TEMPLATES[params[:step].to_sym]
      template = template[params[:type].to_sym] if params[:type]

      session[:hybrid_bill_submission][:submission_type] = params[:type] if params[:type]

      # if params[:step] == 'details' && params[:first_name]
      #   # collect up and submit form data
      #   request_json = HybridBillSubmissionSerializer.serialize(@business_id, @petitioner_object, @agent_object)
      #
      #   response = HybridBillsHelper.api_request.hybridbillpetition.submit.post(body: request_json)
      #   session[:hybrid_bill_submission][:petition_reference] = JSON.parse(response.response.body)['Result']
      #   redirect_to hybrid_bill_path(@business_id, step: 'document-submission')
      # end
      #
      # if params[:step] == 'document-submission' && params[:file]
      #   request_json = HybridBillDocumentSerializer(petition_reference: session['hybrid_bill_submission'][:petition_reference], filename: params[:file].original_file_name, file: params[:file].tempfile)
      #
      #   response = HybridBillsHelper.api_request.hybridbillpetitiondocument.submit.post(body: request_json)
      #   redirect_to hybrid_bill_path(@business_id, step: 'terms-conditions')
      # end
      #
      # if params[:step] == 'terms-conditions'
      #   request_json = HybridBillTermsSerializer(petition_reference: session['hybrid_bill_submission'][:petition_reference])
      #
      #   response = HybridBillsHelper.api_request.hybridbillpetition.accepttermsandconditions.post(body: request_json)
      #   redirect_to hybrid_bill_path(@business_id, step: 'terms-conditions')
      # end

      return render template if template
    end

    session[:hybrid_bill_submission] = {}
  end

  def email
  end

  private

  def validate_business_id
    raise ActionController::RoutingError, 'invalid petition id' unless params[:bill_id] == '1'
  end

  def create_hybrid_bill_submission
    @hybrid_bill_submission = nil

    if %W(details).include?(params[:step])
      type = session[:hybrid_bill_submission][:submission_type].nil? ? params[:type].to_sym : session[:hybrid_bill_submission][:submission_type].to_sym
      petitioner_object = SUBMISSION_TYPES[type]
      petitioner_object = petitioner_object.new if petitioner_object

      @petitioner_object = petitioner_object
    end
  end

end

