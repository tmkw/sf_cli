require 'sf_cli/sf/main'

# The global method that represents *sf* command.
#
# With method chaining, you can use similar syntax as original command.
# @example
#   sf.org.display                           # returns the org information object
#   sf.data.query "SELECT Name FROM Account" # [{"Name"=>"Aethna Home Products"}]
#
def sf
  SfCli::Sf::Main.instance
end
