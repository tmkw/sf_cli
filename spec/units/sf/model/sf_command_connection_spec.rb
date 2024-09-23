require 'sf_cli/sf/model/sf_command_connection'

RSpec.describe 'SfCli::Sf::Model::SfCommandConnection' do
  let(:org) {:dev}
  let(:url) {'hoge.example.com'}
  let(:connection) {SfCli::Sf::Model::SfCommandConnection.new(target_org: org, instance_url: url)}
  let(:sf_org) { instance_double('SfCli::Sf::Org::Core')  }
  let(:sf_data) { instance_double('SfCli::Sf::Data::Core')  }

  let(:id) { anything }
  let(:object_type) { anything }
  let(:klass) { anything }
  let(:model_instance) { anything }
  let(:soql) { 'SELECT Id, Name FROM Hoge__c' }
  let(:query_result) { [anything, anything] }

  before do
    allow(SfCli::Sf::Org::Core).to receive(:new).and_return(sf_org)
    allow(SfCli::Sf::Data::Core).to receive(:new).and_return(sf_data)
  end

  describe '#open' do
    it 'execute `sf org login web`' do
      allow(sf_org).to receive(:login_web).with(target_org: org, instance_url: url)

      connection.open
      expect(sf_org).to have_received :login_web
    end

    context 'if SF_ACCESS_TOKEN is set' do
      before do
        ENV['SF_ACCESS_TOKEN'] = 'xxxxxx'
      end

      after do
        ENV['SF_ACCESS_TOKEN'] = nil
      end

      it 'execute `sf org login access-token`' do
        allow(sf_org).to receive(:login_access_token).with(target_org: org, instance_url: url)

        connection.open
        expect(sf_org).to have_received :login_access_token
      end
    end
  end

  describe '#find' do
    it 'execute `sf data get record`' do
      allow(sf_data).to receive(:get_record).with(object_type, record_id: id, target_org: org, model_class: klass).and_return(model_instance)

      expect(connection.find(object_type, id, klass)).to be model_instance

      expect(sf_data).to have_received :get_record
    end
  end

  describe '#create' do
    let(:params) {{ Name: 'John Smith' }}

    before do
      allow(sf_data).to receive(:create_record).with(object_type, values: params, target_org: org).and_return(id)
    end

    it 'execute `sf data create record`' do
      expect(connection.create(object_type, params)).to be id
      expect(sf_data).to have_received :create_record
    end

    example 'returning model object' do
      allow(connection).to receive(:find).with(object_type, id, klass).and_return(model_instance)

      expect(connection.create(object_type, params, klass)).to be model_instance
      expect(sf_data).to have_received :create_record
      expect(connection).to have_received :find
    end
  end

  describe '#update' do
    let(:params) {{ Name: 'John Smith' }}

    before do
      allow(sf_data).to receive(:update_record).with(object_type, record_id: id, where: nil, values: params, target_org: org).and_return(id)
    end

    it 'execute `sf data update record`' do
      expect(connection.update(object_type, id, params)).to be id
      expect(sf_data).to have_received :update_record
    end
  end

  describe '#delete' do
    before do
      allow(sf_data).to receive(:delete_record).with(object_type, record_id: id, where: nil, target_org: org).and_return(id)
    end

    it 'execute `sf data delete record`' do
      expect(connection.delete(object_type, id)).to be id
      expect(sf_data).to have_received :delete_record
    end
  end

  describe '#query' do
    before do
      allow(sf_data).to receive(:query).with(soql, target_org: org, model_class: klass).and_return(query_result)
    end

    it 'execute `sf data query`' do
      expect(connection.query(soql, klass)).to be query_result
      expect(sf_data).to have_received :query
    end
  end

  describe '#exec_query' do
    let(:fmt) { anything  }
    let(:bulk) { false  }
    let(:timeout) { 5  }

    before do
      allow(sf_data).to receive(:query).with(soql, target_org: org, format: fmt, bulk: bulk, wait: timeout, model_class: klass).and_return(query_result)
    end

    it 'execute `sf data query`' do
      expect(connection.exec_query(soql, format: fmt, bulk: bulk, wait: timeout, model_class: klass)).to be query_result
      expect(sf_data).to have_received :query
    end
  end
end
