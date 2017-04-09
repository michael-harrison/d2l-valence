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

    context 'for DELETE an lti link', vcr: {cassette_name: 'request/execute/delete_lti_link'} do
      let(:http_method) { 'DELETE' }
      let(:route) { '/d2l/api/le/:version/lti/link/:ltiLinkId' }
      let(:route_params) { {ltiLinkId: 144648} }
      let(:query_params) { {} }
      let(:api_version) { '1.15' }
      let(:response) { subject.execute }

      before do
        Timecop.freeze Time.at(1491778588)
      end

      after { Timecop.return }

      it 'will delete the LTI Link' do
        expect(response.code).to eq :HTTP_200
      end
    end
  end
end
