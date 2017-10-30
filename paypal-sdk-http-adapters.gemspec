# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "paypal-sdk-http-adapters"
  spec.version       = "0.1.0"
  spec.authors       = ["Andriy Yanko"]
  spec.email         = ["andriy.yanko@railsware.com"]

  spec.summary       = %q{HTTP Adapters for PayPal SDK}
  spec.homepage      = "https://github.com/railsware/paypal-sdk-http-adapters"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "paypal-sdk-core", ">= 0.3"
  spec.add_development_dependency "em-http-request", "~> 1.1"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.1"
end
