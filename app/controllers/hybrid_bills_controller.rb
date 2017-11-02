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

      require 'pry'; binding.pry

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
      @type = session.fetch('hybrid_bill_submission', {})['submission_type']
      @type = params[:type] if @type.nil?

      return redirect_to hybrid_bill_path(params[:bill_id]) if @type.nil?

      # What object are we trying to build
      petitioner_object = SUBMISSION_TYPES[@type.to_sym]

      if petitioner_object
        # What will the params block for this object be
        params_symbol = petitioner_object.to_s.underscore.to_sym

        begin
          params_object = params[params_symbol] ? sanitized_params(params_symbol) : {}
        rescue ActionController::ParameterMissing => e
          logger.debug 'Redirecting to Hybrid bill home because:'
          logger.debug e

          redirect_to hybrid_bill_path(params[:bill_id])
        end

        petitioner_object = petitioner_object.new(params_object)
        petitioner_object.valid? if params[params_symbol]

        # require 'pry'; binding.pry

        if petitioner_object.has_a_rep == 'true'
          agent_params = petitioner_object.hybrid_bill_agent || {}
          petitioner_object.hybrid_bill_agent = HybridBillAgent.new(agent_params)
          petitioner_object.hybrid_bill_agent.valid?
        else
          petitioner_object.hybrid_bill_agent = HybridBillAgent.new
        end

        if params[params_symbol]
          petitioner_valid = petitioner_object.valid?
          agent_valid = (petitioner_object.has_a_rep == 'true') ? petitioner_object.hybrid_bill_agent.valid? : true

          if petitioner_valid && agent_valid
            request_json = HybridBillSubmissionSerializer.serialize(params[:bill_id], petitioner_object)

            response = HybridBillsHelper.api_request.hybridbillpetition('submit.json').post(body: request_json)
            logger.info "Recieved #{response.response.code}: #{response.response.body}"
            session[:hybrid_bill_submission][:petition_reference] = JSON.parse(response.body)['Result']
            session[:hybrid_bill_submission][:object_params] = params[params_symbol]
            redirect_to hybrid_bill_path(params[:bill_id], step: 'document-submission')
          end
        end
      end

      @petitioner_object = petitioner_object
    end
  end

  def sanitized_params(symbol)
    params.require(symbol).permit(:on_behalf_of, :first_name, :surname, :address_1, :address_2, :postcode, :in_the_uk, :country, :email, :telephone, :receive_updates, :has_a_rep, hybrid_bill_agent: [:first_name, :surname, :address_1, :address_2, :postcode, :in_the_uk, :country, :email, :telephone, :receive_updates])
  end

end

