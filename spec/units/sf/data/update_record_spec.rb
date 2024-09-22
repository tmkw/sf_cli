RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#update_record' do
    let(:object_type) { :TestCustomObject__c  }
    let(:record_id) { 'a record ID'  }
    let(:where) { nil  }
    let(:values) { %|"Name='John White' Age=28"|  }
    let(:target_org) { nil  }
    let(:api_version) { nil  }

    before do
      allow(data).to receive(:exec).with(
        'update record',
        flags: {
          sobject:      object_type,
          where:        where,
          values:       values,
          :"record-id"  => record_id,
          :"target-org" => target_org,
          :"api-version" => api_version,
        },
        redirection: :null_stderr
      )
      .and_return(exec_output)
    end

    it "updates a record, identifying by record ID" do
      id = data.update_record object_type, record_id: record_id, values: {Name: 'John White', Age: 28}
      expect(id).to eq record_id
      expect(data).to have_received :exec
    end

    context "using option: where" do
      let(:record_id) { nil }
      let(:where) { %|"Name='Alan J Smith' Phone='090-XXXX-XXXX'"| }

      it "updates by search conditions" do
        data.update_record object_type, where: {Name: 'Alan J Smith', Phone: '090-XXXX-XXXX'}, values: {Name: 'John White', Age: 28}
        expect(data).to have_received :exec
      end
    end

    context 'using option: target_org' do
      let(:target_org) { :dev }

      it 'updates a record of paticular org' do
        data.update_record object_type, record_id: record_id, values: {Name: 'John White', Age: 28}, target_org: target_org
        expect(data).to have_received :exec
      end
    end

    context 'using option: api_version' do
      let(:api_version) { 61.0 }

      it 'updates a record of paticular org' do
        data.update_record object_type, record_id: record_id, values: {Name: 'John White', Age: 28}, api_version: api_version
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
