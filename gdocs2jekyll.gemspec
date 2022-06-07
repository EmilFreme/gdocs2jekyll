# frozen_string_literal: true

require_relative "lib/gdocs2jekyll/version"

Gem::Specification.new do |spec|
  spec.name = "gdocs2jekyll"
  spec.version = Gdocs2jekyll::VERSION
  spec.authors = ["Emil Freme"]
  spec.email = ["emil@1000fps.co"]

  spec.summary = "Tiny tag generator to embed GDocs in Jekyll post"
  spec.description = "Tiny tag generator to embed GDocs in Jekyll post"
  spec.homepage = "https://github.com/EmilFreme/gdocs2jekyll"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

#  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

#  spec.metadata["homepage_uri"] = spec.homepage
#  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
#  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "jekyll", "~> 4.0"

  spec.add_dependency "http", "~> 5.0.4"
  spec.add_dependency "nokogiri", "~> 1.13.6"
  spec.add_dependency "pandoc-ruby", "~> 2.1.6"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
