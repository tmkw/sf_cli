RSpec.describe 'SfCli::Sf::Data', :model do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#query' do
    let(:job_id) { '750J4000002hj5JIAQ' }
    let(:result_adjuster) { instance_double('SfCli::Sf::Data::Query::BulkResultAdjuster') }
    let(:prepared_record) { {'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"} }

    context 'using option: bulk' do
      before do
        allow(SfCli::Sf::Data::Query::BulkResultAdjuster)
          .to receive(:new).with(success_output, nil).and_return(result_adjuster)
      end

      it "queries with SOQL,  using bulk API" do
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"', :"result-format" => nil, wait: nil},
          switches: {:"bulk" => true},
          redirection: :null_stderr,
          raw_output: false,
          format: :json
        )
        .and_return(success_output)

        allow(result_adjuster).to receive(:get_return_value).and_return([true, [prepared_record]])

        done, rows = data.query 'SELECT Id, Name From Account', bulk: true

        expect(done).to be true
        expect(rows).to contain_exactly(prepared_record)
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end

      example 'setting timeout' do
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"', :"result-format" => nil, wait: 5},
          switches: {:"bulk" => true},
          redirection: :null_stderr,
          raw_output: false,
          format: :json
        )
        .and_return(success_output)

        allow(result_adjuster).to receive(:get_return_value).and_return([true, [prepared_record]])

        done, rows = data.query 'SELECT Id, Name From Account', bulk: true, wait: 5

        expect(done).to be true
        expect(rows).to contain_exactly(prepared_record)
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context 'using bulk api with Model Object convert' do
      let(:prepared_record) { Account.new('Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products") }

      before do
        allow(SfCli::Sf::Data::Query::BulkResultAdjuster)
          .to receive(:new).with(success_output, Account).and_return(result_adjuster)
      end

      it 'converts records from hash object to model object' do
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"', :"result-format" => nil, wait: nil},
          switches: {:"bulk" => true},
          redirection: :null_stderr,
          raw_output: false,
          format: :json
        )
        .and_return(success_output)

        allow(result_adjuster).to receive(:get_return_value).and_return([true, [prepared_record]])

        done, rows = data.query 'SELECT Id, Name From Account', bulk: true, model_class: Account

        expect(done).to be true
        expect(rows).to contain_exactly(prepared_record)
        expect(rows.first.Name).to eq "Aethna Home Products"
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context '(when using bulk api) in case of failure such as query timeout, etc' do
      before do
        allow(SfCli::Sf::Data::Query::BulkResultAdjuster)
          .to receive(:new).with(failure_output, nil).and_return(result_adjuster)
      end

      it 'returns a flag, which implies failure, and a job ID' do
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"', :"result-format" => nil, wait: nil},
          switches: {:"bulk" => true},
          redirection: :null_stderr,
          raw_output: false,
          format: :json
        )
        .and_return(failure_output)

        allow(result_adjuster).to receive(:get_return_value).and_return([false, job_id])

        done, id = data.query 'SELECT Id, Name From Account', bulk: true

        expect(done).to be false
        expect(id).to eq job_id
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context "in case of bulk api with child-parent relationship" do
      let(:prepared_record) { {'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products", 'Account' => {'Name' => 'Hoge Fuga'}} }

      before do
        allow(SfCli::Sf::Data::Query::BulkResultAdjuster)
          .to receive(:new)
          .with(output_including_child_parent_relationship, nil)
          .and_return(result_adjuster)
      end

      it 'returns records including the parent relation fields' do
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"', :"result-format" => nil, :"wait" => nil},
          switches: {:"bulk" => true},
          redirection: :null_stderr,
          raw_output: false,
          format: :json
        )
        .and_return(output_including_child_parent_relationship)

        allow(result_adjuster).to receive(:get_return_value).and_return([true, [prepared_record]])

        done, rows = data.query 'SELECT Id, Name From Account', bulk: true

        expect(done).to be true
        expect(rows).to contain_exactly(prepared_record)
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context 'option combination: bulk and format' do
      let(:result_adjuster) { instance_double('SfCli::Sf::Data::Query::RawOutputResultAdjuster') }

      before do
        allow(SfCli::Sf::Data::Query::RawOutputResultAdjuster).to receive(:new).with(output_formatted_by_csv).and_return(result_adjuster)
      end

      it "returns the command's raw output, which is formatted by particular format" do
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"', :"result-format" => :csv, :"wait" => nil},
          switches: {:"bulk" => true},
          redirection: :null_stderr,
          raw_output: true,
          format: :csv
        )
        .and_return(output_formatted_by_csv)

        allow(result_adjuster).to receive(:get_return_value).and_return(output_formatted_by_csv)

        csv = data.query 'SELECT Id, Name From Account', bulk: true, format: :csv

        expect(csv).to eq output_formatted_by_csv
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end
  end

  def success_output
    {
      "status" => 0,
      "result" => {
        "records" => [
          {
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

  def failure_output
    {
      "status" => 0,
      "result" => {
        "done" => false,
        "records" => [],
        "totalSize" => 0,
        "id" => "#{job_id}"
      }
    }
  end

  def output_formatted_by_csv
    "Id,Name\n0015j00001dsDuhAAE,Aethna Home Products\n"
  end

  def output_including_child_parent_relationship
    {
      "status" => 0,
      "result" => {
        "records" => [
          {
            "Id" => "0015j00001dsDuhAAE",
            "Name" => "Aethna Home Products",
            "Account.Name" => "Hoge Fuga"
          }
        ],
        "totalSize" => 1,
        "done" => true
      },
      "warnings" => []
    }
  end
end
