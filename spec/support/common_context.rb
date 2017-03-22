shared_context :common_context do
  let(:app_id) { ENV['D2L_API_ID'] }
  let(:app_key) { ENV['D2L_API_KEY'] }
  let(:auth_host) { D2L::Valence::Host.new(scheme: :https, host: 'partners.brightspace.com') }
  let(:api_version) { '1.0'}
  let(:app_context) do
    D2L::Valence::AppContext.new(
      brightspace_host: auth_host,
      app_id: app_id,
      app_key: app_key,
      api_version: api_version
    )
  end

  let(:auth_token_parameters) do
    [
      D2L::Valence::AuthTokens::APP_ID_PARAM,
      D2L::Valence::AuthTokens::SIGNATURE_BY_APP_KEY_PARAM,
      D2L::Valence::AuthTokens::SIGNATURE_BY_USER_KEY_PARAM,
      D2L::Valence::AuthTokens::TIMESTAMP_PARAM
    ]
  end

  let(:callback_uri) { URI('https://apitesttool.desire2learnvalence.com/index.php') }
  let(:auth_key) { D2L::Valence::Encrypt.encode(app_key, callback_uri.to_s) }

  let(:user_context) do
    D2L::Valence::UserContext.new(
      app_context: app_context,
      user_id: user_id,
      user_key: user_key
    )
  end
  let(:user_id) { '3' }
  let(:user_key) { 'Vi9NYNbK-l3L' }
end