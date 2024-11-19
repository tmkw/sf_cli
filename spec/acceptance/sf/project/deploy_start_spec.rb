require 'spec_helper'
require_relative '../../../support/shared_examples/sf_project_examples'

RSpec.describe 'sf project deploy start' do
  let(:flag_options) { '--metadata ApexClass ' }
  let(:switch_options) { '--json' }
  let(:redirection) { ' 2> /dev/null' }
  let(:raw_output) { false }

  before do
    allow_any_instance_of(SfCli::Sf::Project::Core)
      .to receive(:`)
      .with("sf project deploy start #{flag_options}#{switch_options}#{redirection}")
      .and_return(command_response)
  end

  it_should_behave_like 'sf project deploy start' do
    subject { sf.project.deploy_start metadata: [:ApexClass] }
  end

  context 'specifying multiple metadata:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--metadata ApexClass CustomObject ' }
      subject { sf.project.deploy_start metadata: [:ApexClass, :CustomObject] }
    end
  end

  context 'specifying manifest file:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--manifest path/to/file ' }
      subject { sf.project.deploy_start manifest: 'path/to/file' }
    end
  end

  context 'specifying source-dir:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--source-dir path/to/file_or_dir ' }
      subject { sf.project.deploy_start source_dir: 'path/to/file_or_dir' }
    end
  end

  context 'specfying target-org:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--metadata ApexClass --target-org dev ' }
      subject { sf.project.deploy_start metadata: [:ApexClass], target_org: :dev }
    end
  end

  context 'specfying api-version:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--metadata ApexClass CustomObject --api-version 61.0 ' }
      subject { sf.project.deploy_start metadata: [:ApexClass, :CustomObject], api_version: 61.0 }
    end
  end

  context "outputing the original command's original output:" do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--metadata ApexClass' }
      let(:switch_options) { '' }
      let(:redirection) { '' }
      let(:raw_output) { true }
      subject { sf.project.deploy_start metadata: [:ApexClass], raw_output: raw_output }
    end
  end

  context 'specfying dry-run:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--metadata ApexClass ' }
      let(:switch_options) { '--json --dry-run' }
      subject { sf.project.deploy_start metadata: [:ApexClass], dry_run: true }
    end
  end

  context 'specfying ignore-conflicts:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--metadata ApexClass ' }
      let(:switch_options) { '--json --ignore-conflicts' }
      subject { sf.project.deploy_start metadata: [:ApexClass], ignore_conflicts: true }
    end
  end

  context 'specfying ignore-errors:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--metadata ApexClass ' }
      let(:switch_options) { '--json --ignore-errors' }
      subject { sf.project.deploy_start metadata: [:ApexClass], ignore_errors: true }
    end
  end

  context 'specfying ignore-warnings:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--metadata ApexClass ' }
      let(:switch_options) { '--json --ignore-warnings' }
      subject { sf.project.deploy_start metadata: [:ApexClass], ignore_warnings: true }
    end
  end

  context 'specfying metadata-dir:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--metadata ApexClass --metadata-dir path/to/dir ' }
      subject { sf.project.deploy_start metadata: [:ApexClass], metadata_dir: 'path/to/dir' }
    end
  end

  context 'specfying single-package:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--metadata ApexClass ' }
      let(:switch_options) { '--json --single-package' }
      subject { sf.project.deploy_start metadata: [:ApexClass], single_package: true }
    end
  end

  context 'specfying a test:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--metadata ApexClass --tests test1 ' }
      subject { sf.project.deploy_start metadata: [:ApexClass], tests: ['test1'] }
    end
  end

  context 'specfying multiple tests:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--metadata ApexClass --tests test1 test2 ' }
      subject { sf.project.deploy_start metadata: [:ApexClass], tests: ['test1', 'test2'] }
    end
  end

  context 'specfying test-level:' do
    it_should_behave_like 'sf project deploy start' do
      let(:flag_options) { '--metadata ApexClass --test-level RunLocalTests ' }
      subject { sf.project.deploy_start metadata: [:ApexClass], test_level: 'RunLocalTests' }
    end
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "checkOnly": false,
          "completedDate": "2024-11-19T00:28:24.000Z",
          "createdBy": "0055j00000AUSsW",
          "createdByName": "maekawa takanobu",
          "createdDate": "2024-11-19T00:28:22.000Z",
          "details": {
            "componentSuccesses": [
              {
                "changed": true,
                "componentType": "",
                "created": false,
                "createdDate": "2024-11-19T00:28:23.000Z",
                "deleted": false,
                "fileName": "package.xml",
                "fullName": "package.xml",
                "success": true
              },
              {
                "changed": true,
                "componentType": "ApexClass",
                "created": true,
                "createdDate": "2024-11-19T00:28:23.000Z",
                "deleted": false,
                "fileName": "classes/MyClass1.cls",
                "fullName": "MyClass1",
                "id": "01pJ4000000YgFKIA0",
                "success": true
              }
            ],
            "runTestResult": {
              "numFailures": 0,
              "numTestsRun": 0,
              "totalTime": 0,
              "codeCoverage": [],
              "codeCoverageWarnings": [],
              "failures": [],
              "flowCoverage": [],
              "flowCoverageWarnings": [],
              "successes": []
            },
            "componentFailures": []
          },
          "done": true,
          "id": "0AfJ4000001t6HWKAY",
          "ignoreWarnings": false,
          "lastModifiedDate": "2024-11-19T00:28:24.000Z",
          "numberComponentErrors": 0,
          "numberComponentsDeployed": 1,
          "numberComponentsTotal": 1,
          "numberTestErrors": 0,
          "numberTestsCompleted": 0,
          "numberTestsTotal": 0,
          "rollbackOnError": true,
          "runTestsEnabled": false,
          "startDate": "2024-11-19T00:28:23.000Z",
          "status": "Succeeded",
          "success": true,
          "files": [
            {
              "fullName": "MyClass1",
              "type": "ApexClass",
              "state": "Created",
              "filePath": "/path/to/force-app/main/default/classes/MyClass1.cls"
            },
            {
              "fullName": "MyClass1",
              "type": "ApexClass",
              "state": "Created",
              "filePath": "/path/to/force-app/main/default/classes/MyClass1.cls-meta.xml"
            }
          ],
          "zipSize": 839,
          "zipFileCount": 3,
          "deployUrl": "https://hoge.bar.baz.my.salesforce.com/lightning/setup/DeployStatus/page?address=aaa.apexp"
        },
        "warnings": []
      }
    JSON
  end
end
