require 'spec_helper'

describe D2L::Valence::AppContext do
  context '.auth_url' do
    subject { described_class.new(brightspace_host: auth_host, app_id: app_id, app_key: app_key) }
    let(:app_id) { ENV['D2L_API_ID'] }
    let(:app_key) { ENV['D2L_API_KEY'] }
    let(:callback_uri) { URI('https://apitesttool.desire2learnvalence.com/index.php') }
    let(:auth_host) { D2L::Valence::Host.new(scheme: :https, host: 'partners.brightspace.com') }
    let(:auth_key) { D2L::Valence::Encrypt.encode(app_key, callback_uri.to_s) }
    let(:expected_url) { "https://partners.brightspace.com/d2l/auth/api/token?x_a=#{app_id}&x_b=#{auth_key}&x_target=#{CGI.escape(callback_uri.to_s)}" }

    it('will generate an authentication URL') do
      expect(subject.auth_url(callback_uri)).to eq expected_url
    end

  end
end
