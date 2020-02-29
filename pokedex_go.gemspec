require_relative 'lib/pokedex_go/version'

Gem::Specification.new do |spec|
  spec.name          = "pokedex_go"
  spec.version       = PokedexGo::VERSION
  spec.authors       = ["James Rogers"]
  spec.email         = ["jarogers095@gmail.com"]

  spec.summary       = "CLI for viewing Pokemon Go creature details"
  spec.description   = "Provides a CLI for viewing Pokemon Go creature details by scraping the data from a handful of websites."
  spec.homepage      = "https://github.com/jarogers095/pokedex_go"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jarogers095/pokedex_go"
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
