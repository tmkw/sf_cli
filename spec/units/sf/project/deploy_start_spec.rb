RSpec.describe 'SfCli::Sf::Project' do
  let(:project) { SfCli::Sf::Project::Core.new }

  describe '#deploy_start' do
    let(:metadata ) { 'ApexClass' }
    let(:manifest ) { nil }
    let(:source_dir ) { nil }
    let(:target_org ) { nil }
    let(:api_version) { nil }
    let(:wait) { nil }
    let(:metadata_dir) { nil }
    let(:tests) { nil }
    let(:test_level) { nil }
    let(:dry_run) { false }
    let(:ignore_conflicts) { false }
    let(:ignore_errors) { false }
    let(:ignore_warnings) { false }
    let(:single_package) { false }
    let(:redirect_type) { :null_stderr }
    let(:raw_output) { false }
    let(:command_output_format) { :json }

    before do
      allow(project)
        .to receive(:exec)
        .with(
          'deploy start',
          flags: {
            :"metadata" => metadata,
            :"manifest" => manifest,
            :"source-dir" => source_dir,
            :"target-org" => target_org,
            :"api-version" => api_version,
            :"wait" => wait,
            :"metadata-dir" => metadata_dir,
            :"tests" => tests,
            :"test-level" => test_level,
          },
          switches: {
            :"dry-run" => dry_run,
            :"ignore-conflicts" => ignore_conflicts,
            :"ignore-errors" => ignore_errors,
            :"ignore-warnings" => ignore_warnings,
            :"single-package" => single_package,
          },
          redirection: redirect_type,
          raw_output:  raw_output,
          format:      command_output_format)
        .and_return(exec_output)
    end

    it "deploy the source files of metadata" do
      result = project.deploy_start metadata: [:ApexClass]

      expect(result).to be_success
      expect(result.files.count).to be 2
      expect(result.files[0].full_name).to eq 'MyClass1'
      expect(result.files[0].type).to eq 'ApexClass'
      expect(result.files[0].state).to eq 'Created'
      expect(result.files[0].file_path).to eq "/path/to/force-app/main/default/classes/MyClass1.cls"

      expect(project).to have_received :exec
    end

    context 'specifying multiple metadata:' do
      let(:metadata ) { 'ApexClass CustomObject' }

      it "retrieve the source files of multiple metadata" do
        project.deploy_start metadata: [:ApexClass, :CustomObject]
        expect(project).to have_received :exec
      end
    end

    context 'specifying manifest file:' do
      let(:metadata ) { nil }
      let(:manifest ) { 'path/to/file' }

      it "deploy the source files which are written in the manifest file" do
        project.deploy_start manifest: manifest
        expect(project).to have_received :exec
      end
    end

    context 'specifying source-dir:' do
      let(:metadata ) { nil }
      let(:source_dir ) { 'path/to/file_or_dir' }

      it "retrieve the source files whose path matches to the specified file or directory" do
        project.deploy_start source_dir: source_dir
        expect(project).to have_received :exec
      end
    end

    context 'using option: target_org' do
      let(:target_org) { :dev }

      it "retrieve the source files in particular org" do
        project.deploy_start metadata: [metadata], target_org: :dev
        expect(project).to have_received :exec
      end
    end

    context 'using option: api_version' do
      let(:api_version) { 61.0 }

      it 'retrieve the source files by paticular API version' do
        project.deploy_start metadata: [metadata], api_version: 61.0
        expect(project).to have_received :exec
      end
    end

    context 'using option: raw_output' do
      let(:redirect_type) { nil }
      let(:raw_output) { true }
      let(:command_output_format) { :human }

      it 'returns the result and errors as same as the original command does' do
        project.deploy_start metadata: [metadata], raw_output: true
        expect(project).to have_received :exec
      end
    end

    context 'specfying dry-run:' do
      let(:dry_run) { true }

      it 'simulate and validate the deploy' do
        project.deploy_start metadata: [metadata], dry_run: true
        expect(project).to have_received :exec
      end
    end

    context 'specfying ignore-conflicts:' do
      let(:ignore_conflicts) { true }

      it 'deploys regardless any conflicts' do
        project.deploy_start metadata: [metadata], ignore_conflicts: true
        expect(project).to have_received :exec
      end
    end

    context 'specfying ignore-errors:' do
      let(:ignore_errors) { true }

      it 'deploys regardless any errors' do
        project.deploy_start metadata: [metadata], ignore_errors: true
        expect(project).to have_received :exec
      end
    end

    context 'specfying ignore-warnings:' do
      let(:ignore_warnings) { true }

      it 'deploys regardless any warnings' do
        project.deploy_start metadata: [metadata], ignore_warnings: true
        expect(project).to have_received :exec
      end
    end

    context 'specfying metadata-dir:' do
      let(:metadata_dir) { 'path/to/dir' }

      it 'deploy the zip files in the specified directory' do
        project.deploy_start metadata: [metadata], metadata_dir: 'path/to/dir'
        expect(project).to have_received :exec
      end
    end

    context 'specfying single-package:' do
      let(:single_package) { true }

      it do
        project.deploy_start metadata: [metadata], single_package: true
        expect(project).to have_received :exec
      end
    end

    context 'specfying an Apex test:' do
      let(:tests) { 'test1' }

      it 'tests the Apex class before deploy' do
        project.deploy_start metadata: [metadata], tests: ['test1']
        expect(project).to have_received :exec
      end
    end

    context 'specfying Apex tests:' do
      let(:tests) { 'test1 test2' }

      it 'tests the Apex classes before deploy' do
        project.deploy_start metadata: [metadata], tests: ['test1 test2']
        expect(project).to have_received :exec
      end
    end

    context 'specfying test level:' do
      let(:test_level) { 'RunLocalTests' }

      it 'tests the Apex classes acording to test level' do
        project.deploy_start metadata: [metadata], test_level: 'RunLocalTests'
        expect(project).to have_received :exec
      end
    end

    context 'specfying time to wait:' do
      let(:wait) { 5 } # 5 min

      it 'waits for the command to complete retrieval until time limt comes' do
        project.deploy_start metadata: [metadata], wait: 5
        expect(project).to have_received :exec
      end
    end
  end

  def exec_output
    {
        "status" => 0,
        "result" => {
          "checkOnly" => false,
          "completedDate" => "2024-11-19T00:28:24.000Z",
          "createdBy" => "0055j00000AUSsW",
          "createdByName" => "maekawa takanobu",
          "createdDate" => "2024-11-19T00:28:22.000Z",
          "details" => {
            "componentSuccesses" => [
              {
                "changed" => true,
                "componentType" => "",
                "created" => false,
                "createdDate" => "2024-11-19T00:28:23.000Z",
                "deleted" => false,
                "fileName" => "package.xml",
                "fullName" => "package.xml",
                "success" => true
              },
              {
                "changed" => true,
                "componentType" => "ApexClass",
                "created" => true,
                "createdDate" => "2024-11-19T00:28:23.000Z",
                "deleted" => false,
                "fileName" => "classes/MyClass1.cls",
                "fullName" => "MyClass1",
                "id" => "01pJ4000000YgFKIA0",
                "success" => true
              }
            ],
            "runTestResult": {
              "numFailures" => 0,
              "numTestsRun" => 0,
              "totalTime" => 0,
              "codeCoverage" => [],
              "codeCoverageWarnings" => [],
              "failures" => [],
              "flowCoverage" => [],
              "flowCoverageWarnings" => [],
              "successes" => []
            },
            "componentFailures" => []
          },
          "done" => true,
          "id" => "0AfJ4000001t6HWKAY",
          "ignoreWarnings" => false,
          "lastModifiedDate" => "2024-11-19T00:28:24.000Z",
          "numberComponentErrors" => 0,
          "numberComponentsDeployed" => 1,
          "numberComponentsTotal" => 1,
          "numberTestErrors" => 0,
          "numberTestsCompleted" => 0,
          "numberTestsTotal" => 0,
          "rollbackOnError" => true,
          "runTestsEnabled" => false,
          "startDate" => "2024-11-19T00:28:23.000Z",
          "status" => "Succeeded",
          "success" => true,
          "files" => [
            {
              "fullName" => "MyClass1",
              "type" => "ApexClass",
              "state" => "Created",
              "filePath" => "/path/to/force-app/main/default/classes/MyClass1.cls"
            },
            {
              "fullName" => "MyClass1",
              "type" => "ApexClass",
              "state" => "Created",
              "filePath" => "/path/to/force-app/main/default/classes/MyClass1.cls-meta.xml"
            }
          ],
          "zipSize" => 839,
          "zipFileCount" => 3,
          "deployUrl" => "https://hoge.bar.baz.my.salesforce.com/lightning/setup/DeployStatus/page?address=aaa.apexp"
        },
        "warnings": []
    }
  end
end
