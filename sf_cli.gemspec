Gem::Specification.new do |s|
  s.name        = "sf_cli"
  s.version     = "0.0.3"
  s.summary     = "A library for using Salesforce CLI in Ruby"
  s.description = "This is a class library for introducing Salesforce CLI to Ruby scripting. Currenty only sf command is the target of development."
  s.authors     = ["Takanobu Maekawa"]
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = "https://github.com/tmkw/sf_cli"
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.3.3'
  s.extra_rdoc_files = ['README.rdoc', 'CHANGELOG.md']
  s.requirements = 'Salesforce CLI ( >= 2.54.0): https://developer.salesforce.com/tools/salesforcecli'
  s.metadata = {
    "homepage_url" => "https://github.com/tmkw/sf_cli"
  }
end

