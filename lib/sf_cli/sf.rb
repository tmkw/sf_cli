require_relative './sf/operations'

module SfCli
  # ==== description
  # The main object class of *sf* command.
  #
  #
  # https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_unified.htm
  #
  # ==== examples
  #  sf = SfCli::Sf.new                     # use default org
  #  sf = SfCli::Sf.new target_org: 'hoge'  # use an alias "hoge" as target org
  #
  #  # get the org connection infomation, which is equivalent to the result of 'sf org display'
  #  sf.org.display 
  #
  #  # get Account records (equivalent to 'sf data query')
  #  sf.data.query 'SELECT Id, Name FROM Account LIMIT 3' # => returns an array containing 3 records
  #
  class Sf
    attr_reader :target_org, :org, :data, :sobject, :project

    #
    # *\target_org* --- an org alias name, which is used for sf command operations (default is nil). If it is nil, the command uses the default org.
    #
    def initialize(target_org: nil)
      @org = Org.new(target_org)
      @data = Data.new(target_org)
      @sobject = SObject.new(target_org)
      @project = Project.new
    end
  end
end
