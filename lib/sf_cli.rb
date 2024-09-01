require 'sf_cli/sf/main'
#
# the global method that represents *sf* command.
# This is desgined as the syntax suger, which can use with similar usability to the original.
#
# For command details, see the {reference document}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_unified.htm]
#
# == examples
#   # you can follow the similar syntax to the original command by using method chain.
#
#   sf.org.display                            # same as original command 'sf org display'
#   sf.data.query "SELECT Name FROM Account"  # same as original command 'sf data query "SELECT Name FROM Account"`
#
def sf
  SfCli::Sf::Main.instance
end
