RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#search'do
    let(:sosl) { 'FIND {TIM OR YOUNG OR OIL} IN Name Fields' }
    let(:target_org) { nil }
    let(:api_version) { nil }
    let(:result_format) { nil }
    let(:format) { :json }
    let(:raw_output) { false }
    let(:output) { exec_output }

    before do
      allow(data).to receive(:exec).with(
        :search,
        flags: {
          :"query" => %|"#{sosl}"|,
          :"target-org" => target_org,
          :"result-format" => result_format,
          :"api-version" => api_version,
        },
        redirection: :null_stderr,
        raw_output: raw_output,
        format: format
      )
      .and_return(output)
    end

    it 'searches objects using SOSL' do
      result = data.search sosl

      expect(result.keys).to contain_exactly('Account', 'Contact', 'User')
      expect(result['Account']).to contain_exactly("0015j00001U2XvMAAV","0015j00001U2XvJAAV")
      expect(result['Contact']).to contain_exactly("0035j00001HB84BAAT","0035j00001HB84AAAT")
      expect(result['User']).to contain_exactly("0055j00000CcL2bAAF")

      expect(data).to have_received :exec
    end

    context 'using option: target_org' do
      let(:target_org) { :dev }

      it 'searches objects in particular org' do
        data.search sosl, target_org: target_org
        expect(data).to have_received :exec
      end
    end

    context 'using option: api_version' do
      let(:api_version) { 61.0 }

      it 'searches objects by particular API version' do
        data.search sosl, api_version: api_version
        expect(data).to have_received :exec
      end
    end

    context 'using option: format => csv' do
      let(:result_format) { :csv }
      let(:format) { :csv }
      let(:raw_output) { true }
      let(:output) { anything }

      it 'downloads csv files that contain result' do
        data.search sosl, format: :csv
      end
    end

    context 'using option: format => human' do
      let(:result_format) { :human }
      let(:format) { :human }
      let(:raw_output) { true }
      let(:output) { human_format_output }

      it 'returns the result by human readable format' do
        result = data.search sosl, format: :human
        expect(result).to eq human_format_output
      end
    end
  end

  def exec_output
    {
      "status" => 0,
      "result" => {
        "searchRecords" => [
          {
            "attributes" => {
              "type" => "Account",
              "url" => "/services/data/v61.0/sobjects/Account/0015j00001U2XvMAAV"
            },
            "Id" => "0015j00001U2XvMAAV"
          },
          {
            "attributes" => {
              "type" => "Account",
              "url" => "/services/data/v61.0/sobjects/Account/0015j00001U2XvJAAV"
            },
            "Id" => "0015j00001U2XvJAAV"
          },
          {
            "attributes" => {
              "type" => "Contact",
              "url" => "/services/data/v61.0/sobjects/Contact/0035j00001HB84BAAT"
            },
            "Id" => "0035j00001HB84BAAT"
          },
          {
            "attributes" => {
              "type" => "Contact",
              "url" => "/services/data/v61.0/sobjects/Contact/0035j00001HB84AAAT"
            },
            "Id" => "0035j00001HB84AAAT"
          },
          {
            "attributes" => {
              "type" => "User",
              "url" => "/services/data/v61.0/sobjects/User/0055j00000CcL2bAAF"
            },
            "Id" => "0055j00000CcL2bAAF"
          }
        ]
      },
      "warnings" => []
    }
  end

  def human_format_output
    <<~EOS
      Account
      ====================
      | Id                 
      | ────────────────── 
      | 0015j00001U2XvNAAV 
      | 0015j00001U2XvMAAV 

      Contact
      ====================
      | Id
      | ──────────────────
      | 0035j00001HB84BAAT
      | 0035j00001HB84AAAT

      User
      ====================
      | Id
      | ──────────────────
      | 0055j00000CcL2bAAF
    EOS
  end
end
