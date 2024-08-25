RSpec.describe 'SfCli::Sf::Data' do
  let(:sf) { instance_double 'SfCli::Sf' }
  let(:data) { SfCli::Sf::Data.new(sf) }

  describe '#query' do
    it "queries with SOQL" do
      allow(sf).to receive(:exec).with(
        'data',
        :query,
        flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"'},
        switches: {},
        redirection: :null_stderr
      )
      .and_return(query_response)

      rows = data.query 'SELECT Id, Name From Account'

      expect(rows).to contain_exactly({'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"})
      expect(sf).to have_received :exec
    end

    example 'returns an array of the model class objects' do
      allow(sf).to receive(:exec).with(
        'data',
        :query,
        flags: {:"target-org" => nil, query: '"SELECT Id, Name From Account"'},
        switches: {},
        redirection: :null_stderr
      )
      .and_return(query_response)

      Account = Struct.new(:Id, :Name)
      rows = data.query 'SELECT Id, Name From Account', model_class: Account

      expect(rows).to contain_exactly( an_object_having_attributes(Id: "0015j00001dsDuhAAE", Name: "Aethna Home Products"))
      expect(rows.first).to be_instance_of Account
      expect(sf).to have_received :exec
    end

    context 'using option: target_org' do
      it 'can query againt a paticular org, not default one' do
        allow(sf).to receive(:exec).with(
          'data',
          :query,
          flags: {:"target-org" => :dev, query: '"SELECT Id, Name From Account"'},
          switches: {},
          redirection: :null_stderr
        )
        .and_return(query_response)

        rows = data.query 'SELECT Id, Name From Account', target_org: :dev

        expect(rows).to contain_exactly({'Id' => "0015j00001dsDuhAAE", 'Name' => "Aethna Home Products"})
        expect(sf).to have_received :exec
      end
    end
  end

  describe '#get_record' do
    let(:object_type) { :TestCustomObject__c  }
    let(:record_id) { 'a record ID'  }

    example "get a record by record ID" do
      allow(sf).to receive(:exec).with(
        'data',
        'get record',
        flags: {
          sobject:      object_type,
          where:        nil,
          :"record-id"  => record_id,
          :"target-org" => nil,
        },
        switches: {},
        redirection: :null_stderr
      )
      .and_return(get_response)
      result = data.get_record object_type, record_id: record_id

      expect(result).to include 'Id' => record_id, 'Name' => 'Akin Kristen'
      expect(sf).to have_received :exec
    end

    example "get a record by search conditions" do
      allow(sf).to receive(:exec).with(
        'data',
        'get record',
        flags: {
          sobject:      object_type,
          where:        %|"Name='Akin Kristen'"|,
          :"record-id"  => nil,
          :"target-org" => nil,
        },
        switches: {},
        redirection: :null_stderr
      )
      .and_return(get_response)

      result = data.get_record object_type, where: {Name: 'Akin Kristen'}
      expect(result).to include 'Id' => record_id, 'Name' => 'Akin Kristen'
      expect(sf).to have_received :exec
    end

    example "get and convert a record into the model object" do
      allow(sf).to receive(:exec).with(
        'data',
        'get record',
        flags: {
          sobject:      object_type,
          where:        nil,
          :"record-id"  => record_id,
          :"target-org" => nil,
        },
        switches: {},
        redirection: :null_stderr
      )
      .and_return(get_response)

      TestCustomObject__c = Struct.new(:Id, :Name)

      object = data.get_record object_type, record_id: record_id, model_class: TestCustomObject__c

      expect(object).to be_instance_of(TestCustomObject__c)
      expect(object).to have_attributes(Id: record_id, Name: 'Akin Kristen')
      expect(sf).to have_received :exec
    end

    context 'using option: target_org' do
      it 'can get a record from the paticular org, not default one' do
        allow(sf).to receive(:exec).with(
          'data',
          'get record',
          flags: {
            sobject:      object_type,
            where:        nil,
            :"record-id"  => record_id,
            :"target-org" => :dev,
          },
          switches: {},
          redirection: :null_stderr
        )
        .and_return(get_response)

        result = data.get_record object_type, record_id: record_id, target_org: :dev
        expect(result).to include 'Id' => record_id, 'Name' => 'Akin Kristen'
        expect(sf).to have_received :exec
      end
    end
  end

  describe '#update_record' do
    let(:object_type) { :TestCustomObject__c  }
    let(:record_id) { 'a record ID'  }

    it "updates a record, identifying by record ID" do
      allow(sf).to receive(:exec).with(
        'data',
        'update record',
        flags: {
          sobject:      object_type,
          where:        nil,
          values:       %|"Name='John White' Age=28"|,
          :"record-id"  => record_id,
          :"target-org" => nil,
        },
        switches: {},
        redirection: :null_stderr
      )
      .and_return(update_response)

      data.update_record object_type, record_id: record_id, values: {Name: 'John White', Age: 28}
      expect(sf).to have_received :exec
    end

    it 'returns the updated record ID' do
      allow(sf).to receive(:exec).with(
        'data',
        'update record',
        flags: {
          sobject:      object_type,
          where:        nil,
          values:       %|"Name='John White' Age=28"|,
          :"record-id"  => record_id,
          :"target-org" => nil,
        },
        switches: {},
        redirection: :null_stderr
      )
      .and_return(update_response)

      id = data.update_record object_type, record_id: record_id, values: {Name: 'John White', Age: 28}
      expect(id).to eq record_id
    end

    it "updates a record, identifying by search conditions" do
      allow(sf).to receive(:exec).with(
        'data',
        'update record',
        flags: {
          sobject:      object_type,
          where:        %|"Name='Alan J Smith' Phone='090-XXXX-XXXX'"|,
          values:       %|"Name='John White' Age=28"|,
          :"record-id"  => nil,
          :"target-org" => nil,
        },
        switches: {},
        redirection: :null_stderr
      )
      .and_return(update_response)

      data.update_record object_type, where: {Name: 'Alan J Smith', Phone: '090-XXXX-XXXX'}, values: {Name: 'John White', Age: 28}
      expect(sf).to have_received :exec
    end

    context 'using option: target_org' do
      it 'can update a record of paticular org, not default one' do
        allow(sf).to receive(:exec).with(
          'data',
          'update record',
          flags: {
            sobject:      object_type,
            where:        nil,
            values:       %|"Name='John White' Age=28"|,
            :"record-id"  => record_id,
            :"target-org" => :dev,
          },
          switches: {},
          redirection: :null_stderr
        )
        .and_return(update_response)

        data.update_record object_type, record_id: record_id, values: {Name: 'John White', Age: 28}, target_org: :dev
        expect(sf).to have_received :exec
      end
    end
  end

  describe '#create_record' do
    let(:object_type) { :TestCustomObject__c  }
    let(:new_record_id) { 'abcdefg'  }

    it "creates a record" do
      allow(sf).to receive(:exec).with(
        'data',
        'create record',
        flags: {
          sobject:      object_type,
          values:        %|"Name='bar hoge' Age=52"|,
          :"target-org" => nil,
        },
        switches: {},
        redirection: :null_stderr
      )
      .and_return(create_response)

      id = data.create_record object_type, values: {Name: 'bar hoge', Age: 52}

      expect(id).to eq new_record_id
      expect(sf).to have_received :exec
    end

    context 'using option: target_org' do
      it "creates an record in the paticular org, not default one" do
        allow(sf).to receive(:exec).with(
          'data',
          'create record',
          flags: {
            sobject:      object_type,
            values:        %|"Name='bar hoge' Age=52"|,
            :"target-org" => :dev,
          },
          switches: {},
          redirection: :null_stderr
        )
        .and_return(create_response)

        id = data.create_record object_type, values: {Name: 'bar hoge', Age: 52}, target_org: :dev

        expect(id).to eq new_record_id
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

  def get_response
    {
      "status" => 0,
      "result" => {
        "attributes" => {
          "type" => "TestCustomObject__c",
          "url" => "/services/data/v61.0/sobjects/TestCustomObject__c/#{record_id}"
        },
        "Id" => "#{record_id}",
        "Name" => "Akin Kristen"
      },
      "warnings" => []
    }
  end

  def update_response
    {
      "status" => 0,
      "result" => {
        "id" => "#{record_id}",
        "success" => true,
        "errors" => []
      },
      "warnings" => []
    }
  end

  def create_response
    {
      "status" => 0,
      "result" => {
        "id" => "#{new_record_id}",
        "success" => true,
        "errors" => []
      },
      "warnings" => []
    }
  end
end
