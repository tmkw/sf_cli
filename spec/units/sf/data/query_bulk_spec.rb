RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#query' do
    let(:prepared_record) { {'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"} }

    context 'using option: bulk' do
      it "queries with SOQL,  using bulk API (default timeout: 1 minute)" do
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"', :"result-format" => nil, :"wait" => 1},
          switches: {:"bulk" => true},
          redirection: :null_stderr,
          raw_output: false,
          format: :json
        )
        .and_return(success_output)

        allow(data).to receive(:prepare_record_in_bulk_mode).with(success_output['result']['records'].first).and_return(prepared_record)

        done, rows = data.query 'SELECT Id, Name From Account', bulk: true

        expect(done).to be true
        expect(rows).to contain_exactly(prepared_record)
        expect(data).to have_received :exec
        expect(data).to have_received :prepare_record_in_bulk_mode
      end

      context "with child-parent relationship" do
        let(:prepared_record) { {'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products", 'Account' => {'Name' => 'Hoge Fuga'}} }

        it 'returns records including the parent relation fields' do
          allow(data).to receive(:exec).with(
            :query,
            flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"', :"result-format" => nil, :"wait" => 1},
            switches: {:"bulk" => true},
            redirection: :null_stderr,
            raw_output: false,
            format: :json
          )
          .and_return(output_including_child_parent_relationship)

          allow(data)
            .to receive(:prepare_record_in_bulk_mode)
            .with(output_including_child_parent_relationship['result']['records'].first)
            .and_return(prepared_record)

          done, rows = data.query 'SELECT Id, Name From Account', bulk: true

          expect(done).to be true
          expect(rows).to contain_exactly(prepared_record)
          expect(data).to have_received :exec
          expect(data).to have_received :prepare_record_in_bulk_mode
        end
      end
    end

    context 'option combination: bulk and format' do
      it "returns the command's raw output, which is formatted by particular format" do
        allow(data).to receive(:exec).with(
          :query,
          flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"', :"result-format" => :csv, :"wait" => 1},
          switches: {:"bulk" => true},
          redirection: :null_stderr,
          raw_output: true,
          format: :csv
        )
        .and_return(output_formatted_by_csv)

        csv = data.query 'SELECT Id, Name From Account', bulk: true, format: :csv

        expect(csv).to eq output_formatted_by_csv
        expect(data).to have_received :exec
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
