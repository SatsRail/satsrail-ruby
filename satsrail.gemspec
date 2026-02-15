# frozen_string_literal: true

require_relative "lib/satsrail"

Gem::Specification.new do |spec|
  spec.name = "satsrail"
  spec.version = SatsRail::VERSION
  spec.authors = ["SatsRail"]
  spec.email = ["support@satsrail.com"]
  spec.summary = "Ruby SDK for the SatsRail Bitcoin payment API"
  spec.description = "Accept Bitcoin payments via Lightning Network, on-chain, and USDT. Zero dependencies."
  spec.homepage = "https://github.com/satsrail/satsrail-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "documentation_uri" => "https://docs.satsrail.com"
  }

  spec.files = Dir["lib/**/*.rb"] + ["README.md", "LICENSE", "satsrail.gemspec"]
  spec.require_paths = ["lib"]
end
