RSpec.describe 'SfCli::Sf::Data', :model do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#query_resume' do
    let(:job_id) { '750J4000002hj5JIAQ' }
    let(:result_adjuster) { instance_double('SfCli::Sf::Data::Query::BulkResultAdjuster') }
    let(:prepared_record) { {'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"} }

    it 'retrieves records with a job id' do
      allow(SfCli::Sf::Data::Query::BulkResultAdjuster).to receive(:new).with(success_output, nil).and_return(result_adjuster)
      allow(data).to receive(:exec).with(
        'query resume',
        flags: {:"target-org" => nil, :"bulk-query-id" => job_id,  :"result-format" => nil},
        redirection: :null_stderr,
        raw_output: false,
        format: :json
      )
      .and_return(success_output)

      allow(result_adjuster).to receive(:get_return_value).and_return([true, [prepared_record]])

      done, rows = data.query_resume job_id: job_id

      expect(done).to be true
      expect(rows).to contain_exactly(prepared_record)
      expect(data).to have_received :exec
      expect(result_adjuster).to have_received :get_return_value
    end

    example 'in case of failure, because query is in progress, etc...' do
      allow(SfCli::Sf::Data::Query::BulkResultAdjuster).to receive(:new).with(failure_output, nil).and_return(result_adjuster)
      allow(data).to receive(:exec).with(
        'query resume',
        flags: {:"target-org" => nil, :"bulk-query-id" => job_id,  :"result-format" => nil},
        redirection: :null_stderr,
        raw_output: false,
        format: :json
      )
      .and_return(failure_output)
      allow(result_adjuster).to receive(:get_return_value).and_return([false, job_id])

      done, id = data.query_resume job_id: job_id

      expect(done).to be false
      expect(id).to eq job_id
      expect(data).to have_received :exec
      expect(result_adjuster).to have_received :get_return_value
    end

    context 'in case of using model class' do
      let(:prepared_record) { Account.new('Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products") }

      it 'converts records from hash object to model object' do
        allow(SfCli::Sf::Data::Query::BulkResultAdjuster).to receive(:new).with(success_output, Account).and_return(result_adjuster)
        allow(data).to receive(:exec).with(
          'query resume',
          flags: {:"target-org" => nil, :"bulk-query-id" => job_id,  :"result-format" => nil},
          redirection: :null_stderr,
          raw_output: false,
          format: :json
        )
        .and_return(success_output)

        allow(result_adjuster).to receive(:get_return_value).and_return([true, [prepared_record]])

        done, rows = data.query_resume job_id: job_id, model_class: Account

        expect(done).to be true
        expect(rows).to contain_exactly(prepared_record)
        expect(rows[0]).to be_instance_of Account
        expect(rows[0].Name).to eq "Aethna Home Products"
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context "in case of records including child-parent relationship" do
      let(:prepared_record) { {'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products", 'Account' => {'Name' => 'Hoge Fuga'}} }

      before do
        allow(SfCli::Sf::Data::Query::BulkResultAdjuster)
          .to receive(:new)
          .with(output_including_child_parent_relationship, nil)
          .and_return(result_adjuster)
      end

      it 'returns records including the parent relation fields' do
        allow(data).to receive(:exec).with(
          'query resume',
          flags: {:"target-org" => nil, :"bulk-query-id" => job_id,  :"result-format" => nil},
          redirection: :null_stderr,
          raw_output: false,
          format: :json
        )
        .and_return(output_including_child_parent_relationship)

        allow(result_adjuster).to receive(:get_return_value).and_return([true, [prepared_record]])

        done, rows = data.query_resume job_id: job_id

        expect(done).to be true
        expect(rows).to contain_exactly(prepared_record)
        expect(data).to have_received :exec
        expect(result_adjuster).to have_received :get_return_value
      end
    end

    context "in case of download csv format data" do
      let(:result_adjuster) { instance_double('SfCli::Sf::Data::Query::RawOutputResultAdjuster') }

      before do
        allow(SfCli::Sf::Data::Query::RawOutputResultAdjuster).to receive(:new).with(csv_output).and_return(result_adjuster)
      end

      it "returns csv output" do
        allow(data).to receive(:exec).with(
          'query resume',
          flags: {:"target-org" => nil, :"bulk-query-id" => job_id,  :"result-format" => :csv},
          redirection: :null_stderr,
          raw_output: true,
          format: :csv
        )
        .and_return(csv_output)

        allow(result_adjuster).to receive(:get_return_value).and_return(csv_output)

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
