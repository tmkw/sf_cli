RSpec.describe 'sf search' do
  let(:sosl) { 'FIND {TIM OR YOUNG OR OIL} IN Name Fields' }

  it 'search objects using SOSL' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with(%|sf data search --query "#{sosl}" --json 2> /dev/null|)
      .and_return(command_response)

    result = sf.data.search sosl

    expect(result.keys).to contain_exactly('Account', 'Contact', 'User')
    expect(result['Account']).to contain_exactly("0015j00001U2XvMAAV","0015j00001U2XvJAAV")
    expect(result['Contact']).to contain_exactly("0035j00001HB84BAAT","0035j00001HB84AAAT")
    expect(result['User']).to contain_exactly("0055j00000CcL2bAAF")
  end

  example 'with accessing to non-default org' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with(%|sf data search --query "#{sosl}" --target-org dev --json 2> /dev/null|)
      .and_return(command_response)

    result = sf.data.search sosl, target_org: :dev
    expect(result.keys).to contain_exactly('Account', 'Contact', 'User')
  end

  example 'csv file download' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with(%|sf data search --query "#{sosl}" --result-format csv 2> /dev/null|)
      .and_return(anything)

    sf.data.search sosl, format: :csv
  end

  example 'human readable format output' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with(%|sf data search --query "#{sosl}" --result-format human 2> /dev/null|)
      .and_return(human_format_output)

    result = sf.data.search sosl, format: :human
    expect(result).to eq human_format_output
  end

  example 'search by particular API version' do
    allow_any_instance_of(SfCli::Sf::Data::Core)
      .to receive(:`)
      .with(%|sf data search --query "#{sosl}" --api-version 61.0 --json 2> /dev/null|)
      .and_return(command_response)

    result = sf.data.search sosl, api_version: 61.0
    expect(result.keys).to contain_exactly('Account', 'Contact', 'User')
  end

  def command_response
    <<~JSON
      {
        "status": 0,
        "result": {
          "searchRecords": [
            {
              "attributes": {
                "type": "Account",
                "url": "/services/data/v61.0/sobjects/Account/0015j00001U2XvMAAV"
              },
              "Id": "0015j00001U2XvMAAV"
            },
            {
              "attributes": {
                "type": "Account",
                "url": "/services/data/v61.0/sobjects/Account/0015j00001U2XvJAAV"
              },
              "Id": "0015j00001U2XvJAAV"
            },
            {
              "attributes": {
                "type": "Contact",
                "url": "/services/data/v61.0/sobjects/Contact/0035j00001HB84BAAT"
              },
              "Id": "0035j00001HB84BAAT"
            },
            {
              "attributes": {
                "type": "Contact",
                "url": "/services/data/v61.0/sobjects/Contact/0035j00001HB84AAAT"
              },
              "Id": "0035j00001HB84AAAT"
            },
            {
              "attributes": {
                "type": "User",
                "url": "/services/data/v61.0/sobjects/User/0055j00000CcL2bAAF"
              },
              "Id": "0055j00000CcL2bAAF"
            }
          ]
        },
        "warnings": []
      }
    JSON
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
