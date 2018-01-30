class HybridBillsController < ApplicationController
  before_action :disable_top_navigation, :disable_status_banner, :enable_asset_overrides
  before_action :validate_business_id, except: :index
  before_action :create_hybrid_bill_submission, only: :show

  STEP_TEMPLATES = {
    'writing-your-petition-online':   'hybrid_bills/steps/writing-your-petition-online',
    'petition-online':                'hybrid_bills/steps/petition-online',
    'details': {
      'individual':         'hybrid_bills/steps/forms/individual',
      'individualgroup':    'hybrid_bills/steps/forms/individualgroup',
      'organisation':       'hybrid_bills/steps/forms/organisation',
      'organisationgroup':  'hybrid_bills/steps/forms/organisationgroup'
    },
    'document-submission':  'hybrid_bills/steps/document-submission',
    'terms-conditions':     'hybrid_bills/steps/terms-conditions',
    'submission-complete':  'hybrid_bills/steps/submission-complete'
  }.freeze

  EMAIL_STEP_TEMPLATES = {
    'individual':        'hybrid_bills/email/individual',
    'individualgroup':   'hybrid_bills/email/individualgroup',
    'organisation':      'hybrid_bills/email/organisation',
    'organisationgroup': 'hybrid_bills/email/organisationgroup'
  }.freeze

  SUBMISSION_TYPES = {
    'individual':        HybridBillIndividualSubmission,
    'individualgroup':   HybridBillIndividualGroupSubmission,
    'organisation':      HybridBillOrganisationSubmission,
    'organisationgroup': HybridBillOrganisationGroupSubmission
  }.freeze

  def index; end

  def show
    session[:hybrid_bill_submission] = session['hybrid_bill_submission'] || {}

    if %i[pre post].include?(status.to_sym)
      return render "hybrid_bills/#{status}"
    elsif status.to_sym == :closed
      redirect_to hybrid_bills_path, notice: 'This petition has closed'
    elsif status.to_sym == :active
      if params[:step]
        template = STEP_TEMPLATES[params[:step].to_sym]

        if @type
          template = template[@type.to_sym]
        end

        session[:hybrid_bill_submission][:submission_type] = @type if @type

        return render template if template
      end

      session[:hybrid_bill_submission] = {}
    else
      raise ActionController::RoutingError, "The status #{status} was not expected."
    end
  end

  def email
    type_param = params[:type] ? params[:type].to_sym : nil
    template = EMAIL_STEP_TEMPLATES[type_param]
    render template if template
  end

  def choose_type
    type_param = params[:type] ? params[:type].to_sym : nil

    return redirect_to hybrid_bill_email_path(@business_id) if type_param.nil?

    redirect_to hybrid_bill_email_path(@business_id, type: type_param)
  end

  def redirect
    redirect_to hybrid_bill_path(@business_id, step: 'writing-your-petition-online', anchor: 'complete-petition')
  end

  private

  def validate_business_id
    @hybrid_bill = HybridBill.find(params[:bill_id])

    raise ActionController::RoutingError, 'invalid petition id' if @hybrid_bill.nil?

    @business_id = params[:bill_id]
  end

  def create_hybrid_bill_submission
    return unless status.to_sym == :active

    process_petitioner_object if %w[details].include?(params[:step])

    process_document_object if %w[document-submission].include?(params[:step])

    process_terms if %w[terms-conditions].include?(params[:step])

    process_complete if %w[submission-complete].include?(params[:step])
  end

  def process_petitioner_object
    @type = params[:type]
    @type = session.fetch('hybrid_bill_submission', {})['submission_type'] if @type.nil?

    return redirect_to hybrid_bill_path(params[:bill_id]) if @type.nil?
    # What object are we trying to build
    petitioner_object = SUBMISSION_TYPES[@type.to_sym]

    if petitioner_object
      # What will the params block for this object be
      params_symbol = petitioner_object.to_s.underscore.to_sym

      # Attempt to get sanitised params for our object
      begin
        params_object = params[params_symbol] ? sanitized_petitioner_params(params_symbol) : {}
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
        agent_valid = petitioner_object.has_a_rep == 'true' ? petitioner_object.hybrid_bill_agent.valid? : true

        if petitioner_valid && agent_valid
          # https://API_URL/hybridbillpetition/submit.json
          request = HybridBillsHelper.api_request.hybridbillpetition('submit.json')
          request_json = HybridBillSubmissionSerializer.serialize(params[:bill_id], petitioner_object)

          begin
            json_response = HybridBillsHelper.process_request(request, request_json, 'Petition Submission')
          rescue Parliament::ClientError, Parliament::ServerError, JSON::ParserError, HybridBillsHelper::HybridBillError, Net::ReadTimeout
            return redirect_to hybrid_bill_path(params[:bill_id]), alert: '.something_went_wrong'
          end
          # Persist our petition reference
          session[:hybrid_bill_submission][:petition_reference] = json_response['Response']

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
        request = HybridBillsHelper.api_request.hybridbillpetitiondocument('submit.json')
        request_json = HybridBillDocumentSerializer.serialize(@petition_reference, document_object)

        begin
          HybridBillsHelper.process_request(request, request_json, 'Petition Submission')
        rescue Parliament::ClientError, Parliament::ServerError, JSON::ParserError, HybridBillsHelper::HybridBillError, Net::ReadTimeout
          return redirect_to hybrid_bill_path(params[:bill_id]), alert: '.something_went_wrong'
        end
        # Persist a flag saying we submitted a document
        session[:hybrid_bill_submission][:document_submitted] = true

        # Send the successful user to the document upload
        redirect_to hybrid_bill_path(params[:bill_id], step: 'terms-conditions')
      else
        @document_object = document_object
      end
    end
  end

  def process_terms
    @petition_reference = session.fetch('hybrid_bill_submission', {})['petition_reference']
    @document_submitted = session.fetch('hybrid_bill_submission', {}).fetch('document_submitted', false)

    return redirect_to hybrid_bill_path(params[:bill_id]) if @petition_reference.nil? || !@document_submitted

    # check that the user has clicked accept
    if params[:hybrid_bill_terms]
      # post to the accept point
      if params[:hybrid_bill_terms][:accepted] == 'true'
        request = HybridBillsHelper.api_request.hybridbillpetition('accepttermsandconditions.json')

        request_json = HybridBillTermsSerializer.serialize(@petition_reference)

        begin
          HybridBillsHelper.process_request(request, request_json, 'Petition Submission')
        rescue Parliament::ClientError, Parliament::ServerError, JSON::ParserError, HybridBillsHelper::HybridBillError, Net::ReadTimeout
          return redirect_to hybrid_bill_path(params[:bill_id]), alert: '.something_went_wrong'
        end

        session[:hybrid_bill_submission][:terms_accepted] = true

        redirect_to hybrid_bill_path(params[:bill_id], step: 'submission-complete')
      end
    end
  end

  def process_complete
    @petition_reference = session.fetch('hybrid_bill_submission', {})['petition_reference']
    @document_submitted = session.fetch('hybrid_bill_submission', {}).fetch('document_submitted', false)
    @terms_accepted = session.fetch('hybrid_bill_submission', {}).fetch('terms_accepted', false)
    @email_addresses = []
    @email_addresses << session.fetch('hybrid_bill_submission', {}).fetch('object_params', {}).fetch('email', [])

    if session['hybrid_bill_submission']['object_params']['has_a_rep'] == "true"
      @email_addresses << session.fetch('hybrid_bill_submission', {}).fetch('object_params', {}).fetch('hybrid_bill_agent', {}).fetch('email', [])
      @email_addresses.flatten!
    end
    return redirect_to hybrid_bill_path(params[:bill_id]), alert: '.something_went_wrong' if @petition_reference.nil? || !@document_submitted || !@terms_accepted
    session[:hybrid_bill_submission] = {}
  end
    
  def sanitized_petitioner_params(symbol)
    params.require(symbol).permit(:on_behalf_of, :first_name, :surname, :address_1, :address_2, :postcode, :in_the_uk, :country, :email, :telephone, :receive_updates, :has_a_rep, hybrid_bill_agent: %i[first_name surname address_1 address_2 postcode in_the_uk country email telephone receive_updates])
  end

  def sanitized_file_params
    params.require(:hybrid_bill_document).permit(:file)
  end

  def status
    return params[:status] if params[:status] && (Rails.env.development? || Rails.env.test?)

    @hybrid_bill.status
  end
end
