module SfCli::Sf::Data
  module Search
    # search objects using SOSL.
    #
    # *sosl* --- SOSL<br>
    #
    # *target_org* --- an alias of paticular org, or username can be used<br>
    #
    # *format* --- get the command's raw output. human, csv, json can be available. *NOTE*: if you choose csv, csv files are downloaded in current directory<br>
    #
    # ======
    #  # example (in irb):
    #
    #  > sf.data.search "FIND {TIM OR YOUNG OR OIL} IN Name Fields"
    #  =>
    #  {"Lead"=>["00Q5j00000WgEuDEAV"],
    #   "Account"=>["0015j00001U2XvNAAV", "0015j00001U2XvMAAV", "0015j00001U2XvJAAV"],
    #   "Contact"=>
    #    ["0035j00001HB84BAAT",
    #     "0035j00001HB84DAAT"],
    #   "Opportunity"=>
    #    ["0065j00001XHJLjAAP",
    #     "0065j00001XHJLTAA5",
    #     "0065j00001XHJLJAA5"],
    #   "User"=>["0055j00000CcL2bAAF", "0055j00000CcL1YAAV"]}
    #
    # For more command details, see {the command reference}[https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm#cli_reference_data_search_unified]
    #
    def search(sosl, target_org: nil, format: nil)
      flags = {
        :"query"         => %|"#{sosl}"|,
        :"target-org"    => target_org,
        :"result-format" => format,
      }
      raw_output = format ? true : false
      format = format&.to_sym || :json

      result = exec(__method__, flags: flags, redirection: :null_stderr, raw_output: raw_output, format: format)

      return if format == :csv
      return result if format == :human

      result['result']['searchRecords']
        .group_by{|r| r['attributes']['type']}
        .each_with_object({}) do |(object_type, records), result|
          result[object_type] = records.map{|r| r['Id']}
        end
    end
  end
end