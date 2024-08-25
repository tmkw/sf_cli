RSpec.describe 'SfCli::Sf::Data' do
  let(:sf) { instance_double 'SfCli::Sf' }
  let(:data) { SfCli::Sf::Data.new(sf) }

  describe '#update_record' do
    let(:object_type) { :TestCustomObject__c  }
    let(:record_id) { 'a record ID'  }

    it "updates a record, identifying by record ID" do
      allow(sf).to receive(:exec).with(
        'data',
        'update record',
        flags: {
          sobject:      object_type,
          where:        nil,
          values:       %|"Name='John White' Age=28"|,
          :"record-id"  => record_id,
          :"target-org" => nil,
        },
        switches: {},
        redirection: :null_stderr
      )
      .and_return(exec_output)

      id = data.update_record object_type, record_id: record_id, values: {Name: 'John White', Age: 28}
      expect(id).to eq record_id
      expect(sf).to have_received :exec
    end

    it "updates a record, identifying by search conditions" do
      allow(sf).to receive(:exec).with(
        'data',
        'update record',
        flags: {
          sobject:      object_type,
          where:        %|"Name='Alan J Smith' Phone='090-XXXX-XXXX'"|,
          values:       %|"Name='John White' Age=28"|,
          :"record-id"  => nil,
          :"target-org" => nil,
        },
        switches: {},
        redirection: :null_stderr
      )
      .and_return(exec_output)

      data.update_record object_type, where: {Name: 'Alan J Smith', Phone: '090-XXXX-XXXX'}, values: {Name: 'John White', Age: 28}
      expect(sf).to have_received :exec
    end

    context 'using option: target_org' do
      it 'can update a record of paticular org, not default one' do
        allow(sf).to receive(:exec).with(
          'data',
          'update record',
          flags: {
            sobject:      object_type,
            where:        nil,
            values:       %|"Name='John White' Age=28"|,
            :"record-id"  => record_id,
            :"target-org" => :dev,
          },
          switches: {},
          redirection: :null_stderr
        )
        .and_return(exec_output)

        data.update_record object_type, record_id: record_id, values: {Name: 'John White', Age: 28}, target_org: :dev
        expect(sf).to have_received :exec
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => {
        "id" => "#{record_id}",
        "success" => true,
        "errors" => []
      },
      "warnings" => []
    }
  end
end
