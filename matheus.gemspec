# frozen_string_literal: true

require_relative "lib/matheus/version"

Gem::Specification.new do |spec|
  spec.name = "matheus"
  spec.version = Matheus::VERSION
  spec.authors = ["Matheus Richard"]
  spec.email = ["matheusrichardt@gmail.com"]

  spec.summary = "A bunch of CLI tools I made for my own use."
  spec.description = spec.summary
  spec.homepage = "https://github.com/MatheusRich/matheus"

  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "zeitwerk", "~> 2.6.17"
  spec.add_dependency "activesupport", "~> 7.2.0"
  spec.add_dependency "ruby-openai", "~> 7.1.0"
  spec.add_dependency "tty-markdown", "~> 0.7.2"
  spec.add_dependency "tty-table", "~> 0.12.0"
  spec.add_dependency "tty-prompt", "~> 0.23.1"
  spec.add_dependency "dotenv", "~> 3.1.2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
