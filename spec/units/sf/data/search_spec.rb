RSpec.describe 'SfCli::Sf::Data' do
  let(:data) { SfCli::Sf::Data::Core.new }

  describe '#search'do
    let(:sosl) { 'FIND {TIM OR YOUNG OR OIL} IN Name Fields' }

    it 'search objects using SOSL' do
      allow(data).to receive(:exec).with(
        :search,
        flags: {
          :"query" => %|"#{sosl}"|,
          :"target-org" => nil,
          :"result-format" => nil,
        },
        redirection: :null_stderr,
        raw_output: false,
        format: :json
      )
      .and_return(exec_output)

      result = data.search sosl

      expect(result.keys).to contain_exactly('Account', 'Contact', 'User')
      expect(result['Account']).to contain_exactly("0015j00001U2XvMAAV","0015j00001U2XvJAAV")
      expect(result['Contact']).to contain_exactly("0035j00001HB84BAAT","0035j00001HB84AAAT")
      expect(result['User']).to contain_exactly("0055j00000CcL2bAAF")

      expect(data).to have_received :exec
    end

    example 'with accessing to non-default org' do
      allow(data).to receive(:exec).with(
        :search,
        flags: {
          :"query" => %|"#{sosl}"|,
          :"target-org" => :dev,
          :"result-format" => nil,
        },
        redirection: :null_stderr,
        raw_output: false,
        format: :json
      )
      .and_return(exec_output)

      result = data.search sosl, target_org: :dev

      expect(result.keys).to contain_exactly('Account', 'Contact', 'User')
      expect(result['Account']).to contain_exactly("0015j00001U2XvMAAV","0015j00001U2XvJAAV")
      expect(result['Contact']).to contain_exactly("0035j00001HB84BAAT","0035j00001HB84AAAT")
      expect(result['User']).to contain_exactly("0055j00000CcL2bAAF")

      expect(data).to have_received :exec
    end

    example 'csv file download' do
      allow(data).to receive(:exec).with(
        :search,
        flags: {
          :"query" => %|"#{sosl}"|,
          :"target-org" => nil,
          :"result-format" => :csv,
        },
        redirection: :null_stderr,
        raw_output: true,
        format: :csv
      )
      .and_return(anything)

      data.search sosl, format: :csv
    end

    example 'human readable format output' do
      allow(data).to receive(:exec).with(
        :search,
        flags: {
          :"query" => %|"#{sosl}"|,
          :"target-org" => nil,
          :"result-format" => :human,
        },
        redirection: :null_stderr,
        raw_output: true,
        format: :human
      )
      .and_return(human_format_output)

      result = data.search sosl, format: :human
      expect(result).to eq human_format_output
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
