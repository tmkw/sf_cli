require 'sf_cli/sf/main'
#
# the global method that represents *sf* command.
#
# With method chaining, you can use similar syntax as original command.
#
# == examples
#
# ======
#   sf.org.display # => returns the org information object
#
# ======
#   sf.data.query "SELECT Name FROM Account" # => [{"Name"=>"Aethna Home Products"}]
#
# For details of sf command, see the {reference guide}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_unified.htm]
#
def sf
  SfCli::Sf::Main.instance
end
