require_relative './bulk_result_v2'

module SfCli::Sf::Data
  module DeleteResume
    def delete_resume(job_id:, timeout: nil, target_org: nil)
      flags = {
        :"job-id"     => job_id,
        :"wait"       => timeout,
        :"target-org" => target_org,
      }
      action = __method__.to_s.tr('_', ' ')
      json = exec(action, flags: flags, redirection: :null_stderr)

      job_info =  ::SfCli::Sf::Data::JobInfo.new(**json['result']['jobInfo'])
      return job_info unless json['result']['records']

      ::SfCli::Sf::Data::BulkResultV2.new(
        job_info: job_info,
        records:  ::SfCli::Sf::Data::BulkRecordsV2.new(**json['result']['records'])
      )
    end
  end
end
