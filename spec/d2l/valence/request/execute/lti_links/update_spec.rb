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

    context 'for PUT with an lti link', vcr: {cassette_name: 'request/execute/put_lti_link'} do
      let(:incorrect_details) { query_params.dup.merge(Title: 'The wrong title') }
      let!(:existing_lit_link) do
        Timecop.freeze Time.at(1491780043) do
          D2L::Valence::Request.new(
            user_context: user_context,
            http_method: 'POST',
            route: '/d2l/api/le/:version/lti/link/:orgUnitId',
            route_params: {orgUnitId: 8041},
            query_params: incorrect_details
          ).execute.to_hash
        end
      end
      let(:http_method) { 'PUT' }
      let(:route) { '/d2l/api/le/:version/lti/link/:ltiLinkId' }
      let(:route_params) { {ltiLinkId: existing_lit_link['LtiLinkId']} }
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
      let(:response) do
        Timecop.freeze Time.at(1491780044) do
          subject.execute
        end
      end

      it 'will update the LTI Link' do
        expect(response.code).to eq :HTTP_200
        expect(response.to_hash['Title']).to eq query_params[:Title]
      end
    end
  end
end
