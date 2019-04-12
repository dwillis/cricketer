
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'cricketer'
  spec.version       = '0.0.2'
  spec.authors       = ['Derek Willis']
  spec.email         = ['dwillis@gmail.com']
  spec.summary       = "A Ruby library for parsing data from ESPN's Cricinfo site."
  spec.description   = 'Parses live scores and game data.'
  spec.homepage      = 'https://github.com/dwillis/cricketer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'fast_attributes', '~> 0.7'
  spec.add_development_dependency 'bundler', '~> 1.16.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2.0'
  spec.add_development_dependency 'vcr', '~> 2.9.3'
  spec.add_development_dependency 'webmock', '~> 3.3'
end
