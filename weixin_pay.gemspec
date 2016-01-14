# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weixin_pay/version'

Gem::Specification.new do |spec|
  spec.name          = "weixin_pay"
  spec.version       = WeixinPay::VERSION
  spec.authors       = ["Jim"]
  spec.email         = ["jim.jin2006@gmail.com"]
  spec.summary       = %q{ Write a short summary. Required.}
  spec.description   = %q{ Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rest-client", '>= 1.6.7'
  spec.add_runtime_dependency 'mime-types'
  spec.add_runtime_dependency 'json', "~> 1.8"


  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
