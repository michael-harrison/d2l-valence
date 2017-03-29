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

    context 'with the timestamp is invalid' do
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/lp/:version/users/whoami' }
      let(:route_params) { {} }
      let(:query_params) { {} }
      let(:expected_path) { "/d2l/api/lp/#{api_version}/users/whoami" }

      context 'on second try', vcr: {cassette_name: 'request/execute/invalid_timestamp'} do
        it 'will succeed' do
          Timecop.freeze DateTime.new(2017, 3, 29, 10, 30, 0) do
            expect(subject.execute.code).to eq :INVALID_TIMESTAMP
          end
          Timecop.freeze DateTime.new(2017, 3, 29, 11, 16, 4) do
            expect(subject.execute.code).to eq :HTTP_200
          end
        end
      end
    end

    context 'for GET', vcr: {cassette_name: 'request/execute/get'} do
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/lp/:version/users/whoami' }
      let(:route_params) { {} }
      let(:query_params) { {} }
      let(:expected_path) { "/d2l/api/lp/#{api_version}/users/whoami" }

      before do
        Timecop.freeze DateTime.new(2017, 3, 29, 9, 19, 39)
      end

      after { Timecop.return }

      its(:execute) { is_expected.to be_a D2L::Valence::Response }
    end
  end
end
