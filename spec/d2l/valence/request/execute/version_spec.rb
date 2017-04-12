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

    context 'for GET version', vcr: {cassette_name: 'request/execute/get_version'} do
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/versions/' }
      let(:route_params) { {} }
      let(:query_params) { {} }
      let(:api_version) { '1.15' }
      let(:response) { subject.execute }

      before do
        Timecop.freeze Time.at(1491960243)
      end

      after { Timecop.return }

      its(:execute) { is_expected.to be_a D2L::Valence::Response }
      it 'will return the version information' do
        response = subject.execute
        expect(response.code).to eq :HTTP_200
      end
    end
  end
end
