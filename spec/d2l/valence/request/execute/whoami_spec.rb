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

    context 'for whoami', vcr: {cassette_name: 'request/execute/get_whoami'} do
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/lp/:version/users/whoami' }
      let(:route_params) { {} }
      let(:query_params) { {} }
      let(:response) { subject.execute }

      before do
        Timecop.freeze Time.at(1491960098)
      end

      after { Timecop.return }

      its(:execute) { is_expected.to be_a D2L::Valence::Response }
      it 'will return the version information' do
        expect(response.to_hash['ProfileIdentifier']).to_not be_nil
        expect(response.code).to eq :HTTP_200
      end
    end
  end
end
