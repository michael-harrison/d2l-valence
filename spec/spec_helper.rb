require 'd2l/valence'
require 'rspec'
require 'rspec/its'
require 'vcr'
require 'webmock/rspec'
require 'timecop'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each {|f| require f }

VCR.configure do |c|
  c.ignore_localhost = true
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
end
