RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#update_record' do
    let(:object_type) { :TestCustomObject__c  }
    let(:record_id) { 'a record ID'  }

    it "updates a record, identifying by record ID" do
      allow(data).to receive(:exec).with(
        'update record',
        flags: {
          sobject:      object_type,
          where:        nil,
          values:       %|"Name='John White' Age=28"|,
          :"record-id"  => record_id,
          :"target-org" => nil,
        },
        redirection: :null_stderr
      )
      .and_return(exec_output)

      id = data.update_record object_type, record_id: record_id, values: {Name: 'John White', Age: 28}
      expect(id).to eq record_id
      expect(data).to have_received :exec
    end

    it "updates a record, identifying by search conditions" do
      allow(data).to receive(:exec).with(
        'update record',
        flags: {
          sobject:      object_type,
          where:        %|"Name='Alan J Smith' Phone='090-XXXX-XXXX'"|,
          values:       %|"Name='John White' Age=28"|,
          :"record-id"  => nil,
          :"target-org" => nil,
        },
        redirection: :null_stderr
      )
      .and_return(exec_output)

      data.update_record object_type, where: {Name: 'Alan J Smith', Phone: '090-XXXX-XXXX'}, values: {Name: 'John White', Age: 28}
      expect(data).to have_received :exec
    end

    context 'using option: target_org' do
      it 'can update a record of paticular org, not default one' do
        allow(data).to receive(:exec).with(
          'update record',
          flags: {
            sobject:      object_type,
            where:        nil,
            values:       %|"Name='John White' Age=28"|,
            :"record-id"  => record_id,
            :"target-org" => :dev,
          },
          redirection: :null_stderr
        )
        .and_return(exec_output)

        data.update_record object_type, record_id: record_id, values: {Name: 'John White', Age: 28}, target_org: :dev
        expect(data).to have_received :exec
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
