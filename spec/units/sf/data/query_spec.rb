RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#query', :model do
    let(:prepared_record) { {'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"} }

    it "queries with SOQL" do
      allow(data).to receive(:exec).with(
        :query,
        flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"'},
        redirection: :null_stderr
      )
      .and_return(exec_output)

      allow(data).to receive(:prepare_record).with(exec_output['result']['records'].first).and_return(prepared_record)

      rows = data.query 'SELECT Id, Name From Account'

      expect(rows).to contain_exactly(prepared_record)
      expect(data).to have_received :exec
      expect(data).to have_received :prepare_record
    end

    example 'returns an array of the model class objects' do
      allow(data).to receive(:exec).with(
        :query,
        flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"'},
        redirection: :null_stderr
      )
      .and_return(exec_output)

      allow(data).to receive(:prepare_record).with(exec_output['result']['records'].first).and_return(prepared_record)

      rows = data.query 'SELECT Id, Name From Account', model_class: Account

      expect(rows).to contain_exactly( an_object_having_attributes(Id: "0015j00001dsDuhAAE", Name: "Aethna Home Products"))
      expect(rows.first).to be_instance_of Account
      expect(data).to have_received :exec
      expect(data).to have_received :prepare_record
    end

    context 'in case of multi sobject query:' do
      let(:prepared_record) { {'Id' => "0035j00001RW3xbAAD", 'Name' => "Akin Kristen", 'Account' => {'Name' => "Aethna Home Products"}} }

      it "returns the combined sobject result" do
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => nil, query: '"SELECT Id, Name, Account.Name FROM Contact Limit 1"'},
          redirection: :null_stderr
        )
        .and_return(exec_output_by_multi_sobject_query)

        allow(data).to receive(:prepare_record).with(exec_output_by_multi_sobject_query['result']['records'].first).and_return(prepared_record)

        rows = data.query 'SELECT Id, Name, Account.Name FROM Contact Limit 1'

        expect(rows).to contain_exactly(prepared_record)
        expect(data).to have_received :exec
        expect(data).to have_received :prepare_record
      end
    end

    context 'using option: target_org' do
      it 'can query againt a paticular org, not default one' do
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => :dev, query: '"SELECT Id, Name From Account"'},
          redirection: :null_stderr
        )
        .and_return(exec_output)

        allow(data).to receive(:prepare_record).with(exec_output['result']['records'].first).and_return(prepared_record)

        rows = data.query 'SELECT Id, Name From Account', target_org: :dev

        expect(rows).to contain_exactly(prepared_record)
        expect(data).to have_received :exec
        expect(data).to have_received :prepare_record
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => {
        "records" => [
          {
            "attributes" => {
              "type" => "Account",
              "url" => "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
            },
            "Id" => "0015j00001dsDuhAAE",
            "Name" => "Aethna Home Products"
          }
        ],
        "totalSize" => 1,
        "done" => true
      },
      "warnings" => []
    }
  end

  def exec_output_by_multi_sobject_query
    {
      "status" => 0,
      "result" => {
        "records" => [
          {
            "attributes" => {
              "type" => "Contact",
              "url" => "/services/data/v61.0/sobjects/Contact/0035j00001RW3xbAAD"
            },
            "Id" => "0035j00001RW3xbAAD",
            "Name" => "Akin Kristen",
            "Account" => {
              "attributes" => {
                "type" => "Account",
                "url" => "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
              },
              "Name" => "Aethna Home Products"
            }
          }
        ],
        "totalSize" => 1,
        "done" => true
      },
      "warnings" => []
    }
  end
end
