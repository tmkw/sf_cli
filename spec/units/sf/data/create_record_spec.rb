RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#create_record' do
    let(:object_type) { :TestCustomObject__c  }
    let(:new_record_id) { 'abcdefg'  }

    it "creates a record" do
      allow(data).to receive(:exec).with(
        'create record',
        flags: {
          sobject:      object_type,
          values:        %|"Name='bar hoge' Age=52"|,
          :"target-org" => nil,
          :"api-version" => nil,
        },
        redirection: :null_stderr
      )
      .and_return(exec_output)

      id = data.create_record object_type, values: {Name: 'bar hoge', Age: 52}

      expect(id).to eq new_record_id
      expect(data).to have_received :exec
    end

    context 'using option: target_org' do
      it "creates an record in the paticular org, not default one" do
        allow(data).to receive(:exec).with(
          'create record',
          flags: {
            sobject:      object_type,
            values:        %|"Name='bar hoge' Age=52"|,
            :"target-org" => :dev,
            :"api-version" => nil,
          },
          redirection: :null_stderr
        )
        .and_return(exec_output)

        id = data.create_record object_type, values: {Name: 'bar hoge', Age: 52}, target_org: :dev

        expect(id).to eq new_record_id
        expect(data).to have_received :exec
      end
    end

    context 'using option: api_version' do
      it "creates an record by particular API version" do
        allow(data).to receive(:exec).with(
          'create record',
          flags: {
            sobject:      object_type,
            values:        %|"Name='bar hoge' Age=52"|,
            :"target-org" => nil,
            :"api-version" => 61.0,
          },
          redirection: :null_stderr
        )
        .and_return(exec_output)

        id = data.create_record object_type, values: {Name: 'bar hoge', Age: 52}, api_version: 61.0

        expect(id).to eq new_record_id
        expect(data).to have_received :exec
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => {
        "id" => "#{new_record_id}",
        "success" => true,
        "errors" => []
      },
      "warnings" => []
    }
  end
end
