# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'co_aspects/version'

Gem::Specification.new do |spec|
  spec.name          = 'co_aspects'
  spec.version       = CoAspects::VERSION
  spec.authors       = ['Gaston Jorquera']
  spec.email         = ['gjorquera@gmail.com']

  spec.summary       = %q{Collection of ready to use aspects.}
  spec.description   =  <<-EOF.gsub(/^\s{4}/, '')
    Collection of ready to use aspects with an annotation-like syntax to attach
    it to methods.
  EOF
  spec.homepage      = 'https://github.com/comparaonline/co_aspects'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 3.0'
  spec.add_dependency 'aspector', '~> 0.14.0'
  spec.add_dependency 'newrelic_rpm', '>= 3.1.1'
  spec.add_dependency 'statsd-instrument', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
