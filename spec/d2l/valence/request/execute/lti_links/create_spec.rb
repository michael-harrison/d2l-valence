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

    context 'for POST', vcr: {cassette_name: 'request/execute/create_lti_link'} do
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
      let(:response) { subject.execute }

      before do
        Timecop.freeze Time.at(1491547058)
      end

      after { Timecop.return }

      it 'will return the version information' do
        expect(response.to_hash['LtiLinkId']).to_not be_nil
        # TODO: When D2L get back to us about the "Send..." attributes all being false we can do the test below
        # query_params.each { |k, v| expect("#{k}: #{response.to_hash[k.to_s]}").to eq "#{k}: #{v}" if k != :PlainSecret }
        expect(response.code).to eq :HTTP_200
      end
    end
  end
end
