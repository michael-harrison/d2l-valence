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
    let(:user_id) { ENV['D2L_USER_ID'] }
    let(:user_key) { ENV['D2L_USER_KEY'] }

    context 'for GET a lti links', vcr: {cassette_name: 'request/execute/get_a_lti_link'} do
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/le/:version/lti/link/:orgUnitId/:ltiLinkId' }
      let(:route_params) { {orgUnitId: 8041, ltiLinkId: 144648} }
      let(:query_params) { {} }
      let(:api_version) { '1.15' }
      let(:response) { subject.execute }

      before do
        Timecop.freeze Time.at(1491547536)
      end

      after { Timecop.return }

      it 'will return the specified lti link for the associated unit' do
        expect(response.code).to eq :HTTP_200
        expect(response.to_hash['LtiLinkId']).to eq route_params[:ltiLinkId]
        expect(response.to_hash['OrgUnitId']).to eq route_params[:orgUnitId]
      end
    end
  end
end
