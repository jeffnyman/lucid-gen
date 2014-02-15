# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lucid-gen/version'

Gem::Specification.new do |spec|
  spec.name          = 'lucid-gen'
  spec.version       = LucidGen::VERSION
  spec.authors       = ['Jeff Nyman']
  spec.email         = ['jeffnyman@gmail.com']
  spec.summary       = %q{Lucid Test Repository Project Generator}
  spec.description   = %q{
    LucidGen generates test repositories for the Lucid framework.
    Lucid is an opinionated framework that has definite ideas about
    how test repositories should be set up. LucidGen allows you to
    create projects that Lucid will, by convention, understand.
  }
  spec.homepage      = 'https://github.com/jnyman/lucid-gen'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
end
