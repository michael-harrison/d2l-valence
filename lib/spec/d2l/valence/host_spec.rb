require 'spec_helper'

describe D2L::Valence::Host do
  context '.initialize' do
    let(:host) { 'www.somehost.com' }

    context 'for scheme string' do
      subject { described_class.new(scheme: 'HTTPS', host: host) }

      its(:scheme) { is_expected.to eq :https }
      its(:host) { is_expected.to eq host }
      its(:port) { is_expected.to be_nil}
    end

    context 'for scheme symbol' do
      subject { described_class.new(scheme: :http, host: host) }

      its(:scheme) { is_expected.to eq :http }
      its(:host) { is_expected.to eq host }
      its(:port) { is_expected.to be_nil}
    end

    context 'for unsupported scheme' do
      it('will raise an exception') do
        expect { described_class.new(scheme: :sftp, host: host) }.to raise_error RuntimeError, 'sftp is an unsupported scheme. Please use either HTTP or HTTPS'
      end
    end
  end

  context '.to_uri' do
    let(:host) { 'www.somehost.com' }

    context 'for HTTP' do
      subject { described_class.new(scheme: :http, host: host, port: port) }

      context 'with no port' do
        let(:port) { nil }

        its('to_uri.to_s') { is_expected.to eq 'http://www.somehost.com' }
      end
      context 'with specific port' do
        let(:port) { 8080 }

        its('to_uri.to_s') { is_expected.to eq 'http://www.somehost.com:8080' }
      end
    end

    context 'for HTTPS' do
      subject { described_class.new(scheme: :https, host: host, port: port) }

      context 'with no port' do
        let(:port) { nil }

        its('to_uri.to_s') { is_expected.to eq 'https://www.somehost.com' }
      end
      context 'with specific port' do
        let(:port) { 4040 }

        its('to_uri.to_s') { is_expected.to eq 'https://www.somehost.com:4040' }
      end
    end
  end

end