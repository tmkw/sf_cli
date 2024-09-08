module SfCli::Sf::Data
  module Search
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
