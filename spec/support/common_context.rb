shared_context :common_context do
  let(:app_id) { ENV['D2L_API_ID'] }
  let(:app_key) { ENV['D2L_API_KEY'] }
  let(:callback_uri) { URI('https://apitesttool.desire2learnvalence.com/index.php') }
  let(:auth_host) { D2L::Valence::Host.new(scheme: :https, host: 'partners.brightspace.com') }
  let(:auth_key) { D2L::Valence::Encrypt.encode(app_key, callback_uri.to_s) }
end