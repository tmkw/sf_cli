RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#query', :model do
    let(:soql) { 'SELECT Id, Name From Account' }
    let(:api_version) { nil }
    let(:target_org) { nil }
    let(:result_format) { nil }
    let(:format) { :json }
    let(:raw_output) { false }
    let(:output) { exec_output }
    let(:model_class) { nil }
    let(:query_result) { [record] }
    let(:result_adjuster) { instance_double('SfCli::Sf::Data::Query::RegularResultAdjuster') }
    let(:record) { {'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"} }

    before do
      allow(data).to receive(:exec).with(
        :query,
        flags: {:"target-org" => target_org, query: %|"#{soql}"|, :"result-format" => result_format, :"wait" => nil, :"api-version" => api_version},
        switches: {bulk: false},
        redirection: :null_stderr,
        raw_output: raw_output,
        format: format
      )
      .and_return(output)
      allow(SfCli::Sf::Data::Query::RegularResultAdjuster).to receive(:new).with(output, model_class).and_return(result_adjuster)
      allow(SfCli::Sf::Data::Query::RawOutputResultAdjuster).to receive(:new).with(output).and_return(result_adjuster)
      allow(result_adjuster).to receive(:get_return_value).and_return(query_result)
    end

    it "queries with SOQL" do
      rows = data.query soql

      expect(rows).to contain_exactly(record)
      expect(data).to have_received :exec
      expect(result_adjuster).to have_received :get_return_value
    end

    context 'using option: csv format' do
      let(:format) { :csv }
      let(:raw_output) { true }
      let(:result_format) { :csv }
      let(:output) { exec_output_formatted_by_csv }
      let(:result_adjuster) { instance_double('SfCli::Sf::Data::Query::RawOutputResultAdjuster') }
      let(:query_result) { output }

      it "returns the raw output formatted by CSV" do
        result = data.query soql, format: :csv

        expect(result).to eq exec_output_formatted_by_csv
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context 'using option: model class' do
      let(:model_class) { Account }
      let(:record) { Account.new('Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products") }

      it 'returns an array of the model class objects' do
        rows = data.query soql, model_class: Account

        expect(rows).to contain_exactly( an_object_having_attributes(Id: "0015j00001dsDuhAAE", Name: "Aethna Home Products"))
        expect(rows.first).to be_instance_of Account
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context 'in case of multi sobject query:' do
      let(:soql){ 'SELECT Id, Name, Account.Name FROM Contact Limit 1' }
      let(:record) { {'Id' => "0035j00001RW3xbAAD", 'Name' => "Akin Kristen", 'Account' => {'Name' => "Aethna Home Products"}} }
      let(:output) { exec_output_by_multi_sobject_query }

      it "returns the combined sobject result" do
        rows = data.query soql

        expect(rows).to contain_exactly(record)
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context 'using option: target_org' do
      let(:target_org) { :dev }

      it 'queries againt paticular org' do
        data.query soql, target_org: target_org
        expect(data).to have_received :exec
      end
    end

    context 'using option: api_version' do
      let(:api_version) { 61.0 }

      it 'queries againt paticular org' do
        data.query soql, api_version: api_version
        expect(data).to have_received :exec
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
