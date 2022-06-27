# frozen_string_literal: true

require_relative "lib/flexible_polyline/version"

Gem::Specification.new do |spec|
  spec.name = "flexible_polyline"
  spec.version = FlexiblePolyline::VERSION
  spec.authors = ["Ozan Bahar"]
  spec.email = ["ozan.bahar@ioki.com"]

  spec.summary = 'A ruby implementation of here`s flexible-polyline library.'
  spec.description = <<~DESCRIPTION
    The flexible polyline encoding from heremaps is a lossy compressed representation of a list of coordinate pairs or coordinate triples. It achieves that by:
    1. Reducing the decimal digits of each value.
    2. Encoding only the offset from the previous point.
    3. Using variable length for each coordinate delta.
    4. Using 64 URL-safe characters to display the result.

    For more information, visit: https://github.com/heremaps/flexible-polyline
  DESCRIPTION
  spec.homepage = 'https://github.com/ioki-mobility/ruby-flexible-polyline'
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  #spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ioki-mobility/ruby-flexible-polyline'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/ioki-mobility/ruby-flexible-polyline/issues'
  spec.metadata['changelog_uri'] = 'https://github.com/ioki-mobility/ruby-flexible-polyline/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
