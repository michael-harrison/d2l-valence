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
      let(:api_version) { '1.15' }
      let(:skewed_start_time) { Time.at(1491940559) }
      # NB: The commented line below is the needed for the regeneration of VCR cassettes
      # let(:skewed_start_time) { Time.at(Time.now.to_i - 20000) }

      context 'on second try', vcr: {cassette_name: 'request/execute/invalid_timestamp'} do
        it 'will succeed' do
          Timecop.travel skewed_start_time do
            expect(subject.execute.code).to eq :INVALID_TIMESTAMP
            expect(subject.execute.code).to eq :HTTP_200
          end
        end
      end
    end
  end
end
