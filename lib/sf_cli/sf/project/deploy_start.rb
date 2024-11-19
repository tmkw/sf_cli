module SfCli::Sf::Project
  module DeployStart
    Result = Struct.new(:done, :details, :id, :status, :success, :files) do
        def success?
          success
        end
      end

    DeployedFile = Data.define(:full_name, :type, :state, :file_path)

    # Deploy metadata to an org from your local project.
    # @param manifest         [String]        path of the manifest file(package.xml) that specifies the components to retrieve
    # @param metadata         [Array]         metadata names that specifies the components to retrieve
    # @param source_dir       [String]        file or directory path to retrieve from the org.
    # @param target_org       [Symbol,String] an alias of paticular org, or username can be used
    # @param api_version      [Numeric]       override the api version used for api requests made by this command
    # @param wait             [Integer]       number of minutes to wait for command to complete
    # @param raw_output       [Boolian]       output what original command shows
    # @param dry_run          [Boolian]       validate deploy and run Apex tests but don’t save to the org.
    # @param ignore_conflicts [Boolian]       ignore conflicts and deploy local files, even if they overwrite changes in the org.
    # @param ignore_errors    [Boolian]       ignore any errors and don’t roll back deployment. Never use this flag when deploying to a production org. 
    # @param ignore_warnings  [Boolian]       ignore warnings and allow a deployment to complete successfully.
    # @param metadata_dir     [Symbol,String] root of directory or zip file of metadata formatted files to deploy.
    # @param single_package   [Boolian]       indicates that the metadata zip file points to a directory structure for a single package.
    # @param tests            [Array]         Apex tests to run when --test-level is RunSpecifiedTests.
    # @param test_level       [Symbol,String] deployment Apex testing level. Available values are NoTestRun, RunSpecifiedTests, RunLocalTests, RunAllTestsInOrg.
    #
    # @return [Result] the retsult of the command
    #
    # @see https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_project_commands_unified.htm#cli_reference_project_deploy_start_unified command reference
    #
    def deploy_start(metadata: nil, manifest: nil,  source_dir: nil, target_org: nil, raw_output: false, metadata_dir: nil, tests: nil, test_level: nil,
      api_version: nil, wait: nil, dry_run: false, ignore_conflicts: false, ignore_errors: false, ignore_warnings: false, single_package: false)

      flags = {
        :manifest       => manifest,
        :metadata       => metadata&.join(' '),
        :"source-dir"   => source_dir,
        :"target-org"   => target_org,
        :"api-version"  => api_version,
        :"metadata-dir" => metadata_dir,
        :tests          => tests&.join(' '),
        :"test-level"   => test_level,
        :"wait"         => wait,
      }
      switches = {
        :"dry-run"          => dry_run,
        :"ignore-conflicts" => ignore_conflicts,
        :"ignore-errors"    => ignore_errors,
        :"ignore-warnings"  => ignore_warnings,
        :"single-package"   => single_package,
      }
      action = __method__.to_s.tr('_', ' ')
      command_output_format = raw_output ? :human : :json
      redirect_type = raw_output ? nil : :null_stderr
      output = exec(action, flags: flags, switches: switches, redirection: redirect_type, raw_output: raw_output, format: command_output_format)
      return output if raw_output

      Result.new(
        done:    output['result']['done'],
        id:      output['result']['id'],
        details: output['result']['details'],
        status:  output['result']['status'],
        success: output['result']['success'],
        files:   output['result']['files'].map{|f| create_deployed_file(f)}
      )
    end

    private

    def create_deployed_file(hash)
      DeployedFile.new(
        full_name: hash['fullName'],
        type:      hash['type'],
        state:     hash['state'],
        file_path: hash['filePath']
      )
    end
  end
end
