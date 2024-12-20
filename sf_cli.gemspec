require_relative 'lib/sf_cli/version'

Gem::Specification.new do |s|
  s.name        = "sf_cli"
  s.version     = SfCli::VERSION
  s.summary     = "A library for introducing Salesforce CLI to Ruby scripting."
  s.description = "A library for introducing Salesforce CLI to Ruby scripting."
  s.authors     = ["Takanobu Maekawa"]
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = "https://github.com/tmkw/sf_cli"
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.3.4'
  s.requirements = 'Salesforce CLI ( >= 2.64.8): https://developer.salesforce.com/tools/salesforcecli'
  s.metadata = {
    "homepage_uri" => "https://github.com/tmkw/sf_cli"
  }
end
