# frozen_string_literal: true

require_relative "lib/dpd_geo_api/version"

Gem::Specification.new do |spec|
  spec.name = "dpd_geo_api"
  spec.version = DpdGeoApi::VERSION
  spec.authors = ["Jakub Malina"]
  spec.email = ["kuba@elegantniweb.cz"]

  spec.summary = "DPD Geo API"
  spec.description = "Ruby gem to connect to DPD geo API"
  spec.homepage = "http://www.elegantniweb.cz"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "http://www.elegantniweb.cz"
  spec.metadata["changelog_uri"] = "http://www.elegantniweb.cz"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
