# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bean_counter/version'

Gem::Specification.new do |spec|
  spec.name          = 'bean_counter'
  spec.version       = BeanCounter::VERSION
  spec.authors       = ['freewrite.org']
  spec.email         = ['dev@freewrite.org']
  spec.description   = %q{Test::Unit assertions for Beaneater}
  spec.summary       = %q{BeanCounter provides additional assertions for testing Ruby code that relies on Beaneater}
  spec.homepage      = 'https://github.com/freewrite/bean_counter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
