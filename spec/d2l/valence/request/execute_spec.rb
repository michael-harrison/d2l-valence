require 'spec_helper'

describe D2L::Valence::Request, type: :service do
  include_context :common_context

  subject do
    described_class.new(
      user_context: user_context,
      http_method: http_method,
      route: route,
      route_params: route_params,
      query_params: query_params
    )
  end

  context '.execute' do
    context 'for GET' do
      let(:api_version) { '1.1' }
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/lp/:version/users/whoami' }
      let(:route_params) { {} }
      let(:query_params) { {} }
      let(:expected_path) { "/d2l/api/lp/#{api_version}/users/whoami" }


    end
  end
end
