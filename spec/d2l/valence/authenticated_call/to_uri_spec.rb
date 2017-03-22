require 'spec_helper'

describe D2L::Valence::AuthenticatedCall, type: :service do
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

  context '.to_uri' do
    context 'with no parameters' do
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/lp/:version/users/whoami' }
      let(:route_params) { {} }
      let(:query_params) { {} }
      let(:expected_path) { '/d2l/api/lp/1.0/users/whoami' }

      its('to_uri.path') { is_expected.to eq expected_path }
      it('will include the authentication query parameters') do
        auth_token_parameters.each { |t| expect(subject.to_uri.query).to include "#{t}=" }
      end
    end

    context 'with a specific API version' do
      let(:api_version) { '1.1' }
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/lp/:version/users/whoami' }
      let(:route_params) { {} }
      let(:query_params) { {} }
      let(:expected_path) { "/d2l/api/lp/#{api_version}/users/whoami" }

      its('to_uri.path') { is_expected.to eq expected_path }
    end

    context 'with route parameters' do
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/lp/:version/:org_unit_id/groupcategories/:group_category_id' }
      let(:route_params) do
        {
          org_unit_id: 4,
          group_category_id: 23,
        }
      end
      let(:query_params) { {} }
      let(:expected_path) { "/d2l/api/lp/#{api_version}/#{route_params[:org_unit_id]}/groupcategories/#{route_params[:group_category_id]}" }

      its('to_uri.path') { is_expected.to eq expected_path }
      it('will include the authentication query parameters') do
        auth_token_parameters.each { |t| expect(subject.to_uri.query).to include "#{t}=" }
      end
    end

    context 'with query parameters' do
      let(:http_method) { 'GET' }
      let(:route) { '/d2l/api/lp/:version/users/' }
      let(:query_params) { {userName: 'student123'} }
      let(:route_params) { {} }
      let(:expected_path) { "/d2l/api/lp/1.0/users/" }

      its('to_uri.path') { is_expected.to eq expected_path }
      it('will include the query params') do
        query_params.each { |k,v| expect(subject.to_uri.query).to include "#{k}=#{v}" }
      end
      it('will include the authentication query parameters') do
        auth_token_parameters.each { |t| expect(subject.to_uri.query).to include "#{t}=" }
      end
    end
  end
end
