# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'brick/version'

Gem::Specification.new do |spec|
  spec.name          = "brick"
  spec.version       = Brick::VERSION
  spec.authors       = ["cheyang"]
  spec.email         = ["cheyang@163.com"]
  spec.summary       = %q{ build, deploy app environment with docker, and can populate complicated configuration files }
  spec.description   = %q{A tool can build and deploy app environment with docker, and can populate complicated configuration files }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 0"
  spec.add_dependency "mixlib-cli", "~> 1.5"
  spec.add_dependency "docker-api", "~> 1.17"
  spec.add_dependency "mixlib-config", ">= 1.1.2", "~> 1.1"
  spec.add_dependency 'colorize', '~> 0.7'
  spec.add_dependency 'thor', '~> 0.19.1'
#  spec.add_dependency "deepstruct", "~> 0.0.7"
end
