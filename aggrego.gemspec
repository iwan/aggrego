# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aggrego/version'

Gem::Specification.new do |spec|
  spec.name          = "aggrego"
  spec.version       = Aggrego::VERSION
  spec.authors       = ["Iwan Buetti"]
  spec.email         = ["iwan.buetti@gmail.com"]
  spec.description   = "Aggregate elements (zones or other) from a set of rules"
  spec.summary       = "Aggregate elements (zones or other) from a set of rules"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
