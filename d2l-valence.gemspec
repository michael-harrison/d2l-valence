# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'd2l/valence/version'

Gem::Specification.new do |spec|
  spec.name          = "d2l-valence"
  spec.version       = D2L::Valence::VERSION
  spec.authors       = ['Michael Harrison']
  spec.email         = ['michael@ereserve.com.au']
  spec.summary       = %q{D2L Valence Learning Framework API client for Ruby}
  spec.description   = %q{A Ruby client for Desire2Learn's Valence Learning Framework APIs primarily used for integration with D2L Brightspace}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client', '~> 2.0.0'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 3.4.0'
  spec.add_development_dependency 'rspec-its', '~> 1.2.0'
  spec.add_development_dependency 'vcr', '~> 3.0.0'
  spec.add_development_dependency 'webmock', '~> 2.0.0'
  spec.add_development_dependency 'timecop', '~> 0.8.1'
end
