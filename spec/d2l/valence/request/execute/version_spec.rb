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

    context 'for whoami', vcr: {cassette_name: 'request/execute/get_whoami', record: :new_episodes} do
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/lp/:version/users/whoami' }
      let(:route_params) { {} }
      let(:query_params) { {} }

      before do
        Timecop.freeze DateTime.new(2017, 3, 29, 9, 19, 39)
      end

      after { Timecop.return }

      its(:execute) { is_expected.to be_a D2L::Valence::Response }
      it 'will return the version information' do
        response = subject.execute
        expect(response.code).to eq :HTTP_200
      end
    end

    context 'for POST', vcr: {cassette_name: 'request/execute/create_lti_link', record: :all} do
      let(:http_method) { 'POST' }
      let(:route) { '/d2l/api/le/:version/lti/link/:orgUnitId' }
      let(:route_params) { {orgUnitId: 8041} }
      let(:query_params) do
        {
          Title: 'LTI Link',
          Url: 'http://myapplication.com/tool/launch',
          Description: 'Link for external tool',
          Key: '2015141297208',
          PlainSecret: 'a30be7c3550149b7a7daac3065f0e5e5',
          IsVisible: false,
          SignMessage: true,
          SignWithTc: true,
          SendTcInfo: true,
          SendContextInfo: true,
          SendUserId: true,
          SendUserName: true,
          SendUserEmail: true,
          SendLinkTitle: true,
          SendLinkDescription: true,
          SendD2LUserName: true,
          SendD2LOrgDefinedId: true,
          SendD2LOrgRoleId: true,
          UseToolProviderSecuritySettings: true,
          CustomParameters: nil
        }
      end
      let(:api_version) { '1.15' }

      it 'will return the version information' do
        response = subject.execute
        expect(response.code).to eq :HTTP_200

      end
    end

    context 'for GET' do

    end

    context 'for PUT' do

    end

    context 'for DELETE' do

    end


    context 'for GET all lti links', vcr: {cassette_name: 'request/execute/get_lti_links'} do
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/le/:version/lti/link/:orgUnitId/' }
      let(:route_params) { {orgUnitId: 8041} }
      let(:query_params) { {} }
      let(:api_version) { '1.15' }
      let(:response) { subject.execute }

      before do
        Timecop.freeze DateTime.new(2017, 4, 7, 3, 22, 46)
      end

      after { Timecop.return }

      its(:execute) { is_expected.to be_a D2L::Valence::Response }
      it 'will return all lti links for the associated unit' do
        response.body.each { |lti_record| expect(lti_record['LtiLinkId']).to_not be_nil }
        expect(response.code).to eq :HTTP_200
      end
    end

    context 'for GET version', vcr: {cassette_name: 'request/execute/get_version'} do
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/versions/' }
      let(:route_params) { {} }
      let(:query_params) { {} }
      let(:api_version) { '1.15' }
      let(:response) { subject.execute }

      before do
        Timecop.freeze DateTime.new(2017, 4, 7, 3, 46, 39)
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
