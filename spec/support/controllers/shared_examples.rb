RSpec.shared_examples 'a data service request' do
  context 'an available data format is requested' do
    before(:each) do
      try(:data_check_methods) || raise('Missing `let` for :data_check_methods used in shared examples')

      headers = { 'Accept' => 'application/rdf+xml' }
      request.headers.merge(headers)
    end

    it 'should have a response with http status redirect (302)' do
      data_check_methods.each do |method|
        if method.include?(:parameters)
          get method[:route].to_sym, params: method[:parameters]
        else
          get method[:route].to_sym
        end
        expect(response).to have_http_status(302)
      end
    end

    it 'redirects to the data service' do
      data_check_methods.each do |method|
        if method.include?(:parameters)
          get method[:route].to_sym, params: method[:parameters]
        else
          get method[:route].to_sym
        end
        expect(response).to redirect_to(method[:data_url])
      end
    end
  end
end
