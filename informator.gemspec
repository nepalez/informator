$:.push File.expand_path("../lib", __FILE__)
require "informator/version"

Gem::Specification.new do |gem|

  gem.name        = "informator"
  gem.version     = Informator::VERSION.dup
  gem.author      = "Andrew Kozin"
  gem.email       = "andrew.kozin@gmail.com"
  gem.homepage    = "https://github.com/nepalez/informator"
  gem.summary     = "Implementation of subscribe/publish design pattern"
  gem.license     = "MIT"

  gem.files            = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files       = Dir["spec/**/*.rb"]
  gem.extra_rdoc_files = Dir["README.md", "LICENSE"]
  gem.require_paths    = ["lib"]

  gem.required_ruby_version = "~> 2.1"

  gem.add_development_dependency "hexx-rspec", "~> 0.4"

end # Gem::Specification
