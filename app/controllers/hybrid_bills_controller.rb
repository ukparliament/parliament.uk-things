
#require_relative '../lib/hybrid_bills'

require 'pry'
require 'pry-nav'

class HybridBillsController < ApplicationController
  # Dummy application index route renders two links to test routing from engine has been added
  
  def index
  end

  # show route added to enable testing of Dummy application routing
  def show
  	raise ActionController::RoutingError, 'invalid petition id' unless validate_petition(params[:bill_id])

  	@petition = params[:bill_id]

  	step_templates = {
  		'submission-type': 'hybrid_bills/steps/1',
  		'covering-page': {
  			'individual': 'hybrid_bills/steps/individual/1',
  			'organisation': 'hybrid_bills/steps/organisation/1',
  			'group': 'hybrid_bills/steps/group/1'
  		},
  		'document-submission': 'hybrid_bills/steps/3',
      'terms-conditions': 'hybrid_bills/steps/4',
  		'complete': 'hybrid_bills/steps/5'
  	}

    #session = new session thing  	
    session['hybrid bills'] = {} if session['hybrid bills'].nil?
    #this shows if there is no step_templates[key]
    template = step_templates[params[:step].to_sym] if params[:step]
    sessionstore = HybridBillsHelper::HybridBillsSessionStore.new(params, session['hybrid bills'])
    
    binding.pry
    template = template[params[:type].to_sym] if params[:step] && params[:type]
    
  	render template if template
  end

  def new
  end

  def create
  end

  # def test
  # 	#response = Parliament::Request::UrlRequest.new(base_url: TEST).get.response.body
  # 	# binding.pry
  # 	# hybridbill_decorator = HybridBillDecorator.new(Parliament::Request::UrlRequest.new(base_url: TEST))
  # 	# p hybridbill_decorator.get_response
  # 	#require 'json'
  # 	# r =  HybridBillsHelper.get_response(HybridBillsHelper::API::TEST)
  # 	# p r
  # 	#binding.pry
  # 	#response = JSON.parse(r)
  	
  # end 

  private

  def validate_petition(id)
  	id == 'hs2' 
  end	

  def add_to_params(params)

     HybridBillsHelper::HybridBillsSessionStore.new(params).set
  end 
  
end

