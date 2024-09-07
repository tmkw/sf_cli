RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#query', :model do
    let(:result_adjuster) { instance_double('SfCli::Sf::Data::Query::RegularResultAdjuster') }
    let(:prepared_record) { {'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"} }

    it "queries with SOQL" do
      allow(SfCli::Sf::Data::Query::RegularResultAdjuster).to receive(:new).with(exec_output, nil).and_return(result_adjuster)
      allow(data).to receive(:exec).with(
        :query,
        flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"', :"result-format" => nil, :"wait" => nil},
        switches: {bulk: false},
        redirection: :null_stderr,
        raw_output: false,
        format: :json
      )
      .and_return(exec_output)

      allow(result_adjuster).to receive(:get_return_value).and_return([prepared_record])

      rows = data.query 'SELECT Id, Name From Account'

      expect(rows).to contain_exactly(prepared_record)
      expect(data).to have_received :exec
      expect(result_adjuster).to have_received :get_return_value
    end

    context 'using option: csv format' do
      let(:result_adjuster) { instance_double('SfCli::Sf::Data::Query::RawOutputResultAdjuster') }

      before do
        allow(SfCli::Sf::Data::Query::RawOutputResultAdjuster).to receive(:new).with(exec_output_formatted_by_csv).and_return(result_adjuster)
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"', :"result-format" => :csv, wait: nil},
          switches: {bulk: false},
          redirection: :null_stderr,
          raw_output: true,
          format: :csv
        )
        .and_return(exec_output_formatted_by_csv)
        allow(result_adjuster).to receive(:get_return_value).and_return(exec_output_formatted_by_csv)
      end

      it "returns the raw output formatted by CSV" do
        output = data.query 'SELECT Id, Name From Account', format: :csv

        expect(output).to eq exec_output_formatted_by_csv
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context 'using option: model class' do
      let(:prepared_record) { Account.new('Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products") }

      before do
        allow(SfCli::Sf::Data::Query::RegularResultAdjuster).to receive(:new).with(exec_output, Account).and_return(result_adjuster)
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"', :"result-format" => nil, wait: nil},
          switches: {bulk: false},
          redirection: :null_stderr,
          raw_output: false,
          format: :json
        )
        .and_return(exec_output)
        allow(result_adjuster).to receive(:get_return_value).and_return([prepared_record])
      end

      it 'returns an array of the model class objects' do
        rows = data.query 'SELECT Id, Name From Account', model_class: Account

        expect(rows).to contain_exactly( an_object_having_attributes(Id: "0015j00001dsDuhAAE", Name: "Aethna Home Products"))
        expect(rows.first).to be_instance_of Account
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context 'in case of multi sobject query:' do
      let(:prepared_record) { {'Id' => "0035j00001RW3xbAAD", 'Name' => "Akin Kristen", 'Account' => {'Name' => "Aethna Home Products"}} }

      before do
        allow(SfCli::Sf::Data::Query::RegularResultAdjuster).to receive(:new).with(exec_output_by_multi_sobject_query, nil).and_return(result_adjuster)
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => nil, query: '"SELECT Id, Name, Account.Name FROM Contact Limit 1"', :"result-format" => nil, wait: nil},
          switches: {bulk: false},
          redirection: :null_stderr,
          raw_output: false,
          format: :json
        )
        .and_return(exec_output_by_multi_sobject_query)
        allow(result_adjuster).to receive(:get_return_value).and_return([prepared_record])
      end

      it "returns the combined sobject result" do
        rows = data.query 'SELECT Id, Name, Account.Name FROM Contact Limit 1'

        expect(rows).to contain_exactly(prepared_record)
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context 'using option: target_org' do
      before do
        allow(SfCli::Sf::Data::Query::RegularResultAdjuster).to receive(:new).with(exec_output, nil).and_return(result_adjuster)
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => :dev, query: '"SELECT Id, Name From Account"', :"result-format" => nil, wait: nil},
          switches: {bulk: false},
          redirection: :null_stderr,
          raw_output: false,
          format: :json
        )
        .and_return(exec_output)
        allow(result_adjuster).to receive(:get_return_value).and_return([prepared_record])
      end

      it 'can query againt a paticular org, not default one' do
        rows = data.query 'SELECT Id, Name From Account', target_org: :dev

        expect(rows).to contain_exactly(prepared_record)
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
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

  def exec_output_formatted_by_csv
    "Id,Name\n0015j00001dsDuhAAE,Aethna Home Products\n"
  end
end
