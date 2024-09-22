RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#delete_record' do
    let(:object_type) { :TestCustomObject__c  }
    let(:record_id) { 'a record ID'  }
    let(:where) { nil  }
    let(:target_org) { nil }
    let(:api_version) { nil  }

    before do
      allow(data).to receive(:exec).with(
        'delete record',
        flags: {
          sobject:       object_type,
          where:         where,
          :"record-id"   => record_id,
          :"target-org"  => target_org,
          :"api-version" => api_version,
        },
        redirection: :null_stderr
      )
      .and_return(exec_output)
    end

    it "deletes a record by record ID" do
      id = data.delete_record object_type, record_id: record_id
      expect(id).to eq record_id
      expect(data).to have_received :exec
    end

    context "using search conditions" do
      let(:record_id) { nil }
      let(:where) { %|"Name='Akin Kristen'"| }

      it "deletes according to search condition" do
        data.delete_record object_type, where: {Name: 'Akin Kristen'}
        expect(data).to have_received :exec
      end
    end

    context 'using option: target_org' do
      let(:target_org) { :dev }

      it "can delete a record of paticular org" do
        data.delete_record object_type, record_id: record_id, target_org: :dev
        expect(data).to have_received :exec
      end
    end

    context 'using option: api_version' do
      let(:api_version) { 61.0 }

      it "can delete a record by particular API version" do
        data.delete_record object_type, record_id: record_id, api_version: api_version
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
