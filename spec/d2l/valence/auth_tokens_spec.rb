require 'spec_helper'

describe D2L::Valence::AuthTokens, type: :service do
  include_context :common_context

  context '.generate' do
    subject { described_class.new(request: request) }
    let(:request) do
      D2L::Valence::Request.new(
        user_context: user_context,
        http_method: 'GET',
        route: '/d2l/api/lp/:version/users/whoami'
      )
    end

    let(:signature) { "#{request.http_method}&#{CGI.unescape(request.path)}&#{subject.adjusted_timestamp}" }
    let(:signature_by_app_key) { D2L::Valence::Encrypt.generate_from(app_key, signature) }
    let(:signature_by_user_key) { D2L::Valence::Encrypt.generate_from(user_key, signature) }
    let(:tokens) { subject.generate }

    it 'will generate the right token values' do
      expect(tokens[described_class::APP_ID_PARAM]).to eq app_id
      expect(tokens[described_class::SIGNATURE_BY_APP_KEY_PARAM]).to eq signature_by_app_key
      expect(tokens[described_class::USER_ID_PARAM]).to eq user_id
      expect(tokens[described_class::SIGNATURE_BY_USER_KEY_PARAM]).to eq signature_by_user_key
      expect(tokens[described_class::TIMESTAMP_PARAM]).to eq subject.adjusted_timestamp
    end
  end

end
