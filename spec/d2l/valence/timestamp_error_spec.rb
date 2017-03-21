require 'spec_helper'

describe D2L::Valence::TimestampError do
  subject { described_class.new(error_message) }

  context 'when there is an error message' do
    let(:server_time_in_seconds) { (Time.now.to_f).to_i + time_skew }
    let(:time_skew) { 60 * 60 }
    let(:error_message) { "Timestamp out of range #{server_time_in_seconds}" }

    its(:timestamp_out_of_range?) { is_expected.to be_truthy }
    its(:server_skew) { is_expected.to_not eq 0 }
  end

  context 'when there is no error message' do
    let(:error_message) { 'This is not a timestamp error message' }

    its(:timestamp_out_of_range?) { is_expected.to be_falsey }
    its(:server_skew) { is_expected.to eq 0 }
  end
end