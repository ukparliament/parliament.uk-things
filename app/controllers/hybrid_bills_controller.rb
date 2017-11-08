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

      if params[:type]
        template = template[params[:type].to_sym]
      elsif @type
        template = template[@type.to_sym]
      end

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

      # require 'pry'; binding.pry

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
    if %W(details).include?(params[:step])
      process_petitioner_object
    end

    if %W(document-submission).include?(params[:step])
      process_document_object
    end
  end

  def process_petitioner_object
    @type = session.fetch('hybrid_bill_submission', {})['submission_type']
    @type = params[:type] if @type.nil?

    return redirect_to hybrid_bill_path(params[:bill_id]) if @type.nil?

    # What object are we trying to build
    petitioner_object = SUBMISSION_TYPES[@type.to_sym]

    if petitioner_object
      # What will the params block for this object be
      params_symbol = petitioner_object.to_s.underscore.to_sym

      # Attempt to get sanitised params for our object
      begin
        params_object = params[params_symbol] ? sanitized_peitioner_params(params_symbol) : {}
      rescue ActionController::ParameterMissing => e
        logger.debug 'Redirecting to Hybrid bill home because:'
        logger.debug e

        redirect_to hybrid_bill_path(params[:bill_id])
      end

      # Create a new petitioner object with our parameters
      petitioner_object = petitioner_object.new(params_object)

      # if the user submitted values, is this object valid? (populates the error object)
      petitioner_object.valid? if params[params_symbol]

      # has the user specified a rep?
      if petitioner_object.has_a_rep == 'true'
        # get the agent object parameters
        agent_params = petitioner_object.hybrid_bill_agent || {}
        # create a new agent
        petitioner_object.hybrid_bill_agent = HybridBillAgent.new(agent_params)
        # check it is valid (populates the error object)
        petitioner_object.hybrid_bill_agent.valid?
      else
        petitioner_object.hybrid_bill_agent = HybridBillAgent.new # create an empty agent
      end

      # Has the user attempted to submit data? If so, see if we can submit it
      if params[params_symbol]
        petitioner_valid = petitioner_object.valid?

        # If the user has asked for a rep, see if the rep is valid. If they have not, rep is valid.
        agent_valid = (petitioner_object.has_a_rep == 'true') ? petitioner_object.hybrid_bill_agent.valid? : true

        if petitioner_valid && agent_valid
          request_json = HybridBillSubmissionSerializer.serialize(params[:bill_id], petitioner_object)

          # TODO: Rescue from client and server errors
          # TODO: Rescue from non-200 status response within a successful response
          response = HybridBillsHelper.api_request.hybridbillpetition('submit.json').post(body: request_json)

          logger.info "Received #{response.response.code}: #{response.response.body}"

          # Persist our petition reference
          session[:hybrid_bill_submission][:petition_reference] = JSON.parse(response.response.body)['Response']

          # Persist our successful params (we will use this if the user goes 'back')
          session[:hybrid_bill_submission][:object_params] = params[params_symbol]

          # Send the successful user to the document upload
          redirect_to hybrid_bill_path(params[:bill_id], step: 'document-submission')
        end
      end
    end

    # Pass the petitioner object to the front-end
    @petitioner_object = petitioner_object
  end

  def process_document_object
    @petition_reference = session.fetch('hybrid_bill_submission', {})['petition_reference']

    return redirect_to hybrid_bill_path(params[:bill_id]) if @petition_reference.nil?

    if params[:hybrid_bill_document]
      document_object = HybridBillDocument.new(sanitized_file_params)

      if document_object.valid?
        request_json = HybridBillDocumentSerializer.serialize(@petition_reference, document_object)

        # TODO: Rescue from client and server errors
        # TODO: Rescue from non-200 status response within a successful response
        response = HybridBillsHelper.api_request.hybridbillpetitiondocument('submit.json').post(body: request_json)

        logger.info "Received #{response.response.code}: #{response.response.body}"

        require 'pry'; binding.pry

        # Persist a flag saying we submitted a document
        session[:hybrid_bill_submission][:document_submitted] = true

        # Send the successful user to the document upload
        redirect_to hybrid_bill_path(params[:bill_id], step: 'terms-conditions')
      end

      @document_object = document_object
    end
  end

  def process_terms
    @petition_reference = session.fetch('hybrid_bill_submission', {})['petition_reference']
    @document_submitted = session.fetch('hybrid_bill_submission', {}).fetch('petition_reference', false)

    return redirect_to hybrid_bill_path(params[:bill_id]) if @petition_reference.nil? && !@document_submitted
  end

  def sanitized_peitioner_params(symbol)
    params.require(symbol).permit(:on_behalf_of, :first_name, :surname, :address_1, :address_2, :postcode, :in_the_uk, :country, :email, :telephone, :receive_updates, :has_a_rep, hybrid_bill_agent: [:first_name, :surname, :address_1, :address_2, :postcode, :in_the_uk, :country, :email, :telephone, :receive_updates])
  end

  def sanitized_file_params
    params.require(:hybrid_bill_document).permit(:file)
  end
end

