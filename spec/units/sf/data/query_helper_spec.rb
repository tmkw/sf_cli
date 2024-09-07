RSpec.describe 'query helpers', :model do
  describe 'SfCli::Sf::Data::Query::RegularResultAdjuster' do
    let(:model_class) { nil }
    let(:result_adjuster) { SfCli::Sf::Data::Query::RegularResultAdjuster.new(regular_result, model_class) }
    let(:prepared_record) { {'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"} }

    before do
      allow(result_adjuster).to receive(:prepare_record).with(regular_result['result']['records'][0]).and_return(prepared_record)
    end

    it 'returns an array of record' do
      rows = result_adjuster.get_return_value

      expect(rows).to contain_exactly(prepared_record)
      expect(result_adjuster).to have_received :prepare_record
    end

    context 'in case of using model class' do
      let(:model_class) { Account }
      let(:model_object) { Account.new('Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products") }

      it 'returns an array of model class' do
        rows = result_adjuster.get_return_value

        expect(rows).to contain_exactly(model_object)
        expect(rows.first).to be_instance_of Account
        expect(rows.first.Name).to eq "Aethna Home Products"
        expect(result_adjuster).to have_received :prepare_record
      end
    end
  end

  describe 'SfCli::Sf::Data::Query::BulkResultAdjuster' do
    let(:model_class) { nil }
    let(:result_adjuster) { SfCli::Sf::Data::Query::BulkResultAdjuster.new(bulk_result, model_class) }
    let(:prepared_record) { {'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"} }

    before do
      allow(result_adjuster).to receive(:prepare_record_in_bulk_mode).with(bulk_result['result']['records'][0]).and_return(prepared_record)
    end

    it 'returns a result flag and an array of record' do
      done, rows = result_adjuster.get_return_value

      expect(done).to be true
      expect(rows).to contain_exactly(prepared_record)
      expect(result_adjuster).to have_received :prepare_record_in_bulk_mode
    end

    context 'when query timeouts or it is still in progress' do
      let(:result_adjuster) { SfCli::Sf::Data::Query::BulkResultAdjuster.new(bulk_failure_result, model_class) }
      let(:job_id) { '750J4000002hj5JIAQ' }

      it 'returns a result flag and job id' do
        done, id = result_adjuster.get_return_value
        expect(done).to be false
        expect(id).to eq job_id
      end
    end

    context 'in case of using model class' do
      let(:model_class) { Account }
      let(:model_object) { Account.new('Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products") }

      it 'returns an array of model class' do
        done, rows = result_adjuster.get_return_value

        expect(done).to be true
        expect(rows).to contain_exactly(model_object)
        expect(rows.first).to be_instance_of Account
        expect(rows.first.Name).to eq "Aethna Home Products"
        expect(result_adjuster).to have_received :prepare_record_in_bulk_mode
      end
    end
  end

  describe 'SfCli::Sf::Data::Query::RawOutputResultAdjuster' do
    let(:result_adjuster) { SfCli::Sf::Data::Query::RawOutputResultAdjuster.new(raw_output_result) }

    it 'simply returns the raw result output itself' do
        expect(result_adjuster.get_return_value).to eq raw_output_result
    end
  end

  def regular_result
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

  def bulk_result
    {
      "status" => 0,
      "result" => {
        "done" => true,
        "records" => [
          {
            "Id" => "0015j00001dsDuhAAE",
            "Name" => "Aethna Home Products"
          }
        ],
        "totalSize" => 1,
      },
      "warnings" => []
    }
  end

  def bulk_failure_result
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

  def raw_output_result
    "Id,Name\n0015j00001dsDuhAAE,Aethna Home Products\n"
  end
end
