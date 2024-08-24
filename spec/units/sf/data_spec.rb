RSpec.describe 'SfCli::Sf::Data' do
  let(:sf) { instance_double 'SfCli::Sf' }
  let(:data) { SfCli::Sf::Data.new(sf) }

  describe '#query' do
  it "queries with SOQL" do
      allow(sf).to receive(:exec).with('data', :query, flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"'}, redirection: :null_stderr).and_return(query_response)

      rows = data.query 'SELECT Id, Name From Account'

      expect(rows).to contain_exactly({'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"})
      expect(sf).to have_received :exec
    end

    context 'using option: target_org' do
      it 'can query againt a paticular org, not default one' do
        allow(sf).to receive(:exec).with('data', :query, flags: {:"target-org" => :dev, query: '"SELECT Id, Name From Account"'}, redirection: :null_stderr).and_return(query_response)
        rows = data.query 'SELECT Id, Name From Account', target_org: :dev

        expect(rows).to contain_exactly({'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"})
        expect(sf).to have_received :exec
      end
    end
  end

  def query_response
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
end