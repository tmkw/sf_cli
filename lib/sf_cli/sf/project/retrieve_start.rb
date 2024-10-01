module SfCli::Sf::Project
  module RetrieveStart
    Result = Data.define(:done, :file_properties, :id, :status, :success, :messages, :files) do
        def success?
          success
        end
      end
    FileProperty = Data.define(:created_by_id, :created_by_name, :created_date, :file_name, :full_name, :id,
                               :last_modified_by_id, :last_modified_by_name, :last_modified_date, :manageable_state, :type)
    RetrievedFile = Data.define(:full_name, :type, :state, :file_path)

    # Retrieve metadata from an org to your local project.
    # @param manifest            [String]        path of the manifest file(package.xml) that specifies the components to retrieve
    # @param metadata            [Array]         metadata names that specifies the components to retrieve
    # @param source_dir          [String]        file or directory path to retrieve from the org.
    # @param package_name        [Array]         package names to retrieve
    # @param target_org          [Symbol,String] an alias of paticular org, or username can be used
    # @param output_dir          [String]        directory root for the retrieved source files
    # @param api_version         [Numeric]       override the api version used for api requests made by this command
    # @param wait                [Integer]       number of minutes to wait for command to complete
    # @param ignore_conflicts    [Boolean]       ignore conflicts and retrieve and save files to your local filesystem
    # @param single_package      [Boolean]       indicates that the zip file points to a directory structure for a single package
    # @param unzip               [Boolian]       number of minutes to wait for command to complete
    # @param target_metadata_dir [String]        indicates that the zip file points to a directory structure for a single package
    # @param zip_file_name       [String]        file name to use for the retrieved zip file
    #
    # @return [Result] the retsult of the command
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_project_commands_unified.htm#cli_reference_project_retrieve_start_unified command reference
    #
    def retrieve_start(metadata: nil, manifest: nil,  source_dir: nil, package_name: nil, target_org: nil, output_dir: nil,
      api_version: nil, wait: nil, target_metadata_dir: nil, zip_file_name: nil, ignore_conflicts: false, single_package: false, unzip: false)

      flags = {
        :manifest              => manifest,
        :metadata              => metadata&.join(' '),
        :"source-dir"          => source_dir,
        :"package-name"        => package_name&.join(' '),
        :"target-org"          => target_org,
        :"output-dir"          => output_dir,
        :"api-version"         => api_version,
        :"wait"                => wait,
        :"target-metadata-dir" => target_metadata_dir,
        :"zip-file-name"       => zip_file_name,
      }
      switches = {
        :"ignore-conflicts" => ignore_conflicts,
        :"single-package" => single_package,
        :"unzip" => unzip,
      }
      action = __method__.to_s.tr('_', ' ')
      json = exec(action, flags: flags, switches: switches, redirection: :null_stderr)

      Result.new(
        done:            json['result']['done'],
        file_properties: json['result']['fileProperties'].map{|fp| create_file_property(fp)},
        id:              json['result']['id'],
        status:          json['result']['status'],
        success:         json['result']['success'],
        messages:        json['result']['messages'],
        files:           json['result']['files'].map{|f| create_retrieved_file(f)}
      )
    end

    private

    def create_file_property(hash)
      FileProperty.new(
        created_by_id:         hash['createdById'],
        created_by_name:       hash['createdByName'],
        created_date:          hash['createdDate'],
        file_name:             hash['fileName'],
        full_name:              hash['fullName'],
        id:                    hash['id'],
        last_modified_by_id:   hash['lastModifiedById'],
        last_modified_by_name: hash['lastModifiedByName'],
        last_modified_date:    hash['lastModifiedDate'],
        manageable_state:      hash['manageableState'],
        type:                  hash['type']
      )
    end

    def create_retrieved_file(hash)
      RetrievedFile.new(
        full_name: hash['fullName'],
        type:      hash['type'],
        state:     hash['state'],
        file_path: hash['filePath']
      )
    end
  end
end
