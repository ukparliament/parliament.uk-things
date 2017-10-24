
#require_relative '../lib/hybrid_bills'

require 'pry'
require 'pry-nav'

class HybridBillsController < ApplicationController
  before_action :disable_top_navigation, :disable_status_banner
  before_action :validate_petition, only: :show
  before_action :create_hybrid_bill_submission, only: :show

  include HybridBillsHelper

  STEP_TEMPLATES = {
    'send-a-petition':                       'hybrid_bills/steps/send-a-petition',
    'writing-your-petition':                 'hybrid_bills/steps/writing-your-petition',
    'who-are-you-submitting-a-petition-for': 'hybrid_bills/steps/who-are-you-submitting-a-petition-for',
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
    individual: HybridBillIndividualSubmission
  }

  def index
  end

  def show
  	@petition = params[:bill_id]

    if params[:step]
      template = STEP_TEMPLATES[params[:step].to_sym]
      template = template[params[:type].to_sym] if params[:type]

      return render template if template
    end
  end

  def email
  end

  private

  def validate_petition
    raise ActionController::RoutingError, 'invalid petition id' unless params[:bill_id] == 'hs2'
  end

  def create_hybrid_bill_submission
    @hybrid_bill_submission = nil
  end

end

