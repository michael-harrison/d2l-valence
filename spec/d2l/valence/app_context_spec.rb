require 'spec_helper'

describe D2L::Valence::AppContext, type: :service do
  include_context :common_context

  context '.auth_url' do
    subject { described_class.new(brightspace_host: auth_host, app_id: app_id, app_key: app_key) }
    let(:expected_url) { "https://partners.brightspace.com/d2l/auth/api/token?x_a=#{app_id}&x_b=#{auth_key}&x_target=#{CGI.escape(callback_uri.to_s)}" }

    it('will generate an authentication URL') do
      expect(subject.auth_url(callback_uri)).to eq expected_url
    end

  end
end
