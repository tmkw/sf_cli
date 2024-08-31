RSpec.describe 'SfCli::Sf::Data' do
  let(:sf) { instance_double 'SfCli::Sf::Core' }
  let(:data) { SfCli::Sf::Data::Core.new(sf) }

  describe '#delete_record' do
    let(:object_type) { :TestCustomObject__c  }
    let(:record_id) { 'a record ID'  }

    it "deletes a record by record ID" do
      allow(sf).to receive(:exec).with(
        'data',
        'delete record',
        flags: {
          sobject:      object_type,
          where:        nil,
          :"record-id"  => record_id,
          :"target-org" => nil,
        },
        switches: {},
        redirection: :null_stderr
      )
      .and_return(exec_output)
      id = data.delete_record object_type, record_id: record_id
      expect(id).to eq record_id
      expect(sf).to have_received :exec
    end

    it "deletes a record by search conditions" do
      allow(sf).to receive(:exec).with(
        'data',
        'delete record',
        flags: {
          sobject:      object_type,
          where:        %|"Name='Akin Kristen'"|,
          :"record-id"  => nil,
          :"target-org" => nil,
        },
        switches: {},
        redirection: :null_stderr
      )
      .and_return(exec_output)

      data.delete_record object_type, where: {Name: 'Akin Kristen'}
      expect(sf).to have_received :exec
    end

    context 'using option: target_org' do
      it "can delete a record of paticular org, not default one" do
        allow(sf).to receive(:exec).with(
          'data',
          'delete record',
          flags: {
            sobject:      object_type,
            where:        nil,
            :"record-id"  => record_id,
            :"target-org" => :dev,
          },
          switches: {},
          redirection: :null_stderr
        )
        .and_return(exec_output)

        data.delete_record object_type, record_id: record_id, target_org: :dev
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
