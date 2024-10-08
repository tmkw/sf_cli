RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#get_record', :model do
    let(:object_type) { :TestCustomObject__c  }
    let(:record_id) { 'a record ID'  }

    example "get a record by record ID" do
      allow(data).to receive(:exec).with(
        'get record',
        flags: {
          sobject:      object_type,
          where:        nil,
          :"record-id"  => record_id,
          :"target-org" => nil,
        },
        redirection: :null_stderr
      )
      .and_return(exec_output)
      result = data.get_record object_type, record_id: record_id

      expect(result).to include 'Id' => record_id, 'Name' => 'Akin Kristen'
      expect(data).to have_received :exec
    end

    example "get a record by search conditions" do
      allow(data).to receive(:exec).with(
        'get record',
        flags: {
          sobject:      object_type,
          where:        %|"Name='Akin Kristen'"|,
          :"record-id"  => nil,
          :"target-org" => nil,
        },
        redirection: :null_stderr
      )
      .and_return(exec_output)

      result = data.get_record object_type, where: {Name: 'Akin Kristen'}
      expect(result).to include 'Id' => record_id, 'Name' => 'Akin Kristen'
      expect(data).to have_received :exec
    end

    example "get and convert a record into the model object" do
      allow(data).to receive(:exec).with(
        'get record',
        flags: {
          sobject:      object_type,
          where:        nil,
          :"record-id"  => record_id,
          :"target-org" => nil,
        },
        redirection: :null_stderr
      )
      .and_return(exec_output)

      object = data.get_record object_type, record_id: record_id, model_class: TestCustomObject__c

      expect(object).to be_instance_of(TestCustomObject__c)
      expect(object).to have_attributes(Id: record_id, Name: 'Akin Kristen')
      expect(data).to have_received :exec
    end

    context 'using option: target_org' do
      it 'can get a record from the paticular org, not default one' do
        allow(data).to receive(:exec).with(
          'get record',
          flags: {
            sobject:      object_type,
            where:        nil,
            :"record-id"  => record_id,
            :"target-org" => :dev,
          },
          redirection: :null_stderr
        )
        .and_return(exec_output)

        result = data.get_record object_type, record_id: record_id, target_org: :dev
        expect(result).to include 'Id' => record_id, 'Name' => 'Akin Kristen'
        expect(data).to have_received :exec
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => {
        "attributes" => {
          "type" => "TestCustomObject__c",
          "url" => "/services/data/v61.0/sobjects/TestCustomObject__c/#{record_id}"
        },
        "Id" => "#{record_id}",
        "Name" => "Akin Kristen"
      },
      "warnings" => []
    }
  end
end
