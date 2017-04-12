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

    context 'for GET all lti links', vcr: {cassette_name: 'request/execute/get_lti_links'} do
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/le/:version/lti/link/:orgUnitId/' }
      let(:route_params) { {orgUnitId: 8041} }
      let(:query_params) { {} }
      let(:api_version) { '1.15' }
      let(:response) { subject.execute }

      before do
        Timecop.freeze Time.at(1491960964)
      end

      after { Timecop.return }

      its(:execute) { is_expected.to be_a D2L::Valence::Response }
      it 'will return all lti links for the associated unit' do
        expect(response.code).to eq :HTTP_200
        response.to_hash.each { |lti_record| expect(lti_record['LtiLinkId']).to_not be_nil }
      end
    end
  end
end
