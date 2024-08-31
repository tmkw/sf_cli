RSpec.describe 'SfCli::Sf::Sobject' do
  let(:sf) { instance_double 'SfCli::Sf::Core' }
  let(:sobject) { SfCli::Sf::Sobject::Core.new(sf) }

  describe '#list' do
    example "returns all object list" do
      allow(sf).to receive(:exec).with('sobject', :list, flags: {:"target-org" => nil, sobject: :all}, switches: {}, redirection: :null_stderr).and_return(exec_output)
      result = sobject.list :all

      expect(result).to include 'Account'
      expect(result).to include 'TestCustomObject__c'

      expect(sf).to have_received :exec
    end

    example "returns all custom object list" do
      allow(sf).to receive(:exec).with('sobject', :list, flags: {:"target-org" => nil, sobject: :custom}, switches: {}, redirection: :null_stderr).and_return(exec_output custom_only: true)
      result = sobject.list :custom

      expect(result).to include 'TestCustomObject__c'
      expect(sf).to have_received :exec
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
