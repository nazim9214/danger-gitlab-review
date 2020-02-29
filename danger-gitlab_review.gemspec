# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitlab_review/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'danger-gitlab_review'
  spec.version       = GitlabReview::VERSION
  spec.authors       = ['']
  spec.email         = ['']
  spec.description   = %q{Randomly select reviewers for Gitlab MR}
  spec.summary       = %q{Randomly select reviewers for Gitlab MR.}
  spec.homepage      = 'https://github.com//danger-gitlab_review'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'danger-plugin-api', '~> 1.0'

  # General ruby development
  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'

  # Testing support
  spec.add_development_dependency 'rspec', '~> 3.4'

  # Linting code and docs
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "yard"

  # Makes testing easy via `bundle exec guard`
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'

  # If you want to work on older builds of ruby
  spec.add_development_dependency 'listen', '3.0.7'

  # This gives you the chance to run a REPL inside your tests
  # via:
  #
  #    require 'pry'
  #    binding.pry
  #
  # This will stop test execution and let you inspect the results
  spec.add_development_dependency 'pry'
end
