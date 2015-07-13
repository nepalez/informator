$:.push File.expand_path("../lib", __FILE__)
require "informator/version"

Gem::Specification.new do |gem|

  gem.name     = "informator"
  gem.version  = Informator::VERSION.dup
  gem.author   = "Andrew Kozin"
  gem.email    = "andrew.kozin@gmail.com"
  gem.homepage = "https://github.com/nepalez/informator"
  gem.summary  = "Implementation of publish/subscribe design pattern"
  gem.license  = "MIT"

  gem.files            = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files       = Dir["spec/**/*.rb"]
  gem.extra_rdoc_files = Dir["README.md", "LICENSE"]
  gem.require_paths    = ["lib"]

  gem.required_ruby_version = "~> 1.9.3"

  gem.add_runtime_dependency "i18n", "~> 0.7"
  gem.add_runtime_dependency "ice_nine", "~> 0.11"
  gem.add_runtime_dependency "inflecto", "~> 0.0"

  gem.add_development_dependency "hexx-rspec", "~> 0.5"
  gem.add_development_dependency "equalizer", "~> 0.0"

end # Gem::Specification
