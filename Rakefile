# encoding: utf-8

require "rubygems"
require "bundler/setup"

# Loads bundler tasks
Bundler::GemHelper.install_tasks

# Loads the Hexx::RSpec and its tasks
begin
  require "hexx-suit"
  Hexx::Suit.install_tasks
rescue LoadError
  require "hexx-rspec"
  Hexx::RSpec.install_tasks
end

# Sets the Hexx::RSpec :test task to default
task default: "test:coverage:run"

desc "Runs mutation metric for testing"
task :mutant do
  system "bundle exec mutant -r informator --use rspec Informator* --fail-fast"
end

desc "Exhort all evils"
task :mutant do
  system "bundle exec mutant -r informator --use rspec Informator*"
end
