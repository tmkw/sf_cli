RSpec.describe 'SfCli::Sf::Data' do
  let(:sf) { instance_double 'SfCli::Sf::Core' }
  let(:data) { SfCli::Sf::Data::Core.new(sf) }

  describe '#create_record' do
    let(:object_type) { :TestCustomObject__c  }
    let(:new_record_id) { 'abcdefg'  }

    it "creates a record" do
      allow(sf).to receive(:exec).with(
        'data',
        'create record',
        flags: {
          sobject:      object_type,
          values:        %|"Name='bar hoge' Age=52"|,
          :"target-org" => nil,
        },
        switches: {},
        redirection: :null_stderr
      )
      .and_return(exec_output)

      id = data.create_record object_type, values: {Name: 'bar hoge', Age: 52}

      expect(id).to eq new_record_id
      expect(sf).to have_received :exec
    end

    context 'using option: target_org' do
      it "creates an record in the paticular org, not default one" do
        allow(sf).to receive(:exec).with(
          'data',
          'create record',
          flags: {
            sobject:      object_type,
            values:        %|"Name='bar hoge' Age=52"|,
            :"target-org" => :dev,
          },
          switches: {},
          redirection: :null_stderr
        )
        .and_return(exec_output)

        id = data.create_record object_type, values: {Name: 'bar hoge', Age: 52}, target_org: :dev

        expect(id).to eq new_record_id
        expect(sf).to have_received :exec
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
