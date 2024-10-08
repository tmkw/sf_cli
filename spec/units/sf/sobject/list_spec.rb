RSpec.describe 'SfCli::Sf::Sobject' do
  let(:sobject) { SfCli::Sf::Sobject::Core.new }

  describe '#list' do
    example "returns all object list" do
      allow(sobject)
        .to receive(:exec)
        .with(:list, flags: {:"target-org" => nil, sobject: :all, :"api-version" => nil}, redirection: :null_stderr)
        .and_return(exec_output)

      result = sobject.list :all

      expect(result).to include 'Account'
      expect(result).to include 'TestCustomObject__c'

      expect(sobject).to have_received :exec
    end

    example "returns all custom object list" do
      allow(sobject)
        .to receive(:exec)
        .with(:list, flags: {:"target-org" => nil, sobject: :custom, :"api-version" => nil}, redirection: :null_stderr)
        .and_return(exec_output custom_only: true)

      result = sobject.list :custom

      expect(result).to include 'TestCustomObject__c'
      expect(sobject).to have_received :exec
    end

    example "using option: target_org" do
      allow(sobject)
        .to receive(:exec)
        .with(:list, flags: {:"target-org" => :dev, sobject: :all, :"api-version" => nil}, redirection: :null_stderr)
        .and_return(exec_output custom_only: true)

      result = sobject.list :all, target_org: :dev

      expect(result).to include 'TestCustomObject__c'
      expect(sobject).to have_received :exec
    end

    example "using option: api_version" do
      allow(sobject)
        .to receive(:exec)
        .with(:list, flags: {:"target-org" => nil, sobject: :all, :"api-version" => 61.0}, redirection: :null_stderr)
        .and_return(exec_output custom_only: true)

      result = sobject.list :all, api_version: 61.0

      expect(result).to include 'TestCustomObject__c'
      expect(sobject).to have_received :exec
    end
  end

  def exec_output(custom_only: false)
    {
      "status" => 0,
      "result" => custom_only ? ["TestCustomObject__c"] : ["Account", "TestCustomObject__c"],
      "warnings" => []
    }
  end
end
