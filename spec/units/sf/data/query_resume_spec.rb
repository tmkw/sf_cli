RSpec.describe 'SfCli::Sf::Data', :model do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#query_resume' do
    let(:job_id) { '750J4000002hj5JIAQ' }
    let(:api_version) { nil }
    let(:target_org) { nil }
    let(:result_format) { nil }
    let(:format) { :json }
    let(:raw_output) { false }
    let(:output) { success_output }
    let(:model_class) { nil }
    let(:query_result) { [true, [record]]}
    let(:result_adjuster) { instance_double('SfCli::Sf::Data::Query::RegularResultAdjuster') }
    let(:record) { {'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"} }

    before do
      allow(data).to receive(:exec).with(
        'query resume',
        flags: {:"target-org" => target_org, :"bulk-query-id" => job_id,  :"result-format" => result_format, :"api-version" => api_version},
        redirection: :null_stderr,
        raw_output: raw_output,
        format: format
      )
      .and_return(output)
      allow(SfCli::Sf::Data::Query::BulkResultAdjuster).to receive(:new).with(output, model_class).and_return(result_adjuster)
      allow(SfCli::Sf::Data::Query::RawOutputResultAdjuster).to receive(:new).with(output).and_return(result_adjuster)
      allow(result_adjuster).to receive(:get_return_value).and_return(query_result)
    end

    it 'retrieves records with a job id' do
      done, rows = data.query_resume job_id: job_id

      expect(done).to be true
      expect(rows).to contain_exactly(record)
      expect(data).to have_received :exec
      expect(result_adjuster).to have_received :get_return_value
    end

    context 'using option: target_org' do
      let(:target_org){ :dev }

      it 'retrieves records of particular org' do
        data.query_resume job_id: job_id, target_org: target_org
        expect(data).to have_received :exec
      end
    end

    context 'using option: api_version' do
      let(:api_version){ 61.0 }

      it 'retrieves records by particular API version' do
        data.query_resume job_id: job_id, api_version: api_version
        expect(data).to have_received :exec
      end
    end

    context 'in case of failure, because query is in progress, etc...' do
      let(:output) { failure_output }
      let(:query_result) { [false, job_id] }

      it 'returns [false, job_id]' do
        done, id = data.query_resume job_id: job_id

        expect(done).to be false
        expect(id).to eq job_id
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context 'in case of using model class' do
      let(:model_class) { Account }
      let(:record) { Account.new('Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products") }

      it 'converts records from hash object to model object' do
        done, rows = data.query_resume job_id: job_id, model_class: Account

        expect(done).to be true
        expect(rows).to contain_exactly(record)
        expect(rows[0]).to be_instance_of Account
        expect(rows[0].Name).to eq "Aethna Home Products"
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context "in case of records including child-parent relationship" do
      let(:output) { output_including_child_parent_relationship }
      let(:record) { {'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products", 'Account' => {'Name' => 'Hoge Fuga'}} }

      it 'returns records including the parent relation fields' do
        done, rows = data.query_resume job_id: job_id

        expect(done).to be true
        expect(rows).to contain_exactly(record)
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context "in case of download csv format data" do
      let(:format) { :csv }
      let(:raw_output) { true }
      let(:result_format) { :csv }
      let(:output) { csv_output }
      let(:result_adjuster) { instance_double('SfCli::Sf::Data::Query::RawOutputResultAdjuster') }
      let(:query_result) { csv_output }

      it "returns csv output" do
        csv  = data.query_resume job_id: job_id, format: :csv

        expect(csv).to eq csv_output
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

  def csv_output
    "Id,Name\n0015j00001dsDuhAAE,Aethna Home Products\n"
  end
end
