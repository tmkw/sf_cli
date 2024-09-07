require_relative '../core/base'
require_relative './query'
require_relative './get_record'
require_relative './update_record'
require_relative './create_record'
require_relative './delete_record'
require_relative './delete_bulk'
require_relative './delete_resume'
require_relative './upsert_bulk'
require_relative './upsert_resume'

module SfCli
  module Sf
    module Data
      #
      # ==== description
      # The class representing *sf* *data*
      #
      # https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_data_commands_unified.htm
      #
      class Core
        include ::SfCli::Sf::Core::Base
        include Query
        include GetRecord
        include UpdateRecord
        include CreateRecord
        include DeleteRecord
        include DeleteBulk
        include DeleteResume
        include UpsertBulk
        include UpsertResume
      end
    end
  end
end
