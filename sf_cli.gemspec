Gem::Specification.new do |s|

  s.name        = "sf_cli"

  s.version     = "0.0.2"

  s.summary     = "A library for Salesforce CLI"

  s.description = "A thin wrapper classes simulating Salesforce CLI. Currenty only sf command is implemented.Not all functions are supported."

  s.authors     = ["Takanobu Maekawa"]

  s.files       = Dir['lib/**/*.rb']

  s.homepage    = "https://github.com/tmkw/sf_cli"

  s.license     = 'MIT'

  s.required_ruby_version = '>= 3.3.3'

  s.extra_rdoc_files = ['README']

  s.requirements = 'Salesforce CLI (https://developer.salesforce.com/tools/salesforcecli)'

  s.metadata = {

    "homepage_url" => "https://github.com/tmkw/sf_cli"

  }

end

