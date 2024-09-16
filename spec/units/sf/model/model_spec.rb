require 'sf_cli/sf/model'

RSpec.describe 'SfCli::Sf::Model' do
  let(:connection) { anything }

  describe '.set_connection' do
    it 'set connection object in Model module' do
      SfCli::Sf::Model.set_connection connection

      expect(SfCli::Sf::Model.connection).to be connection
    end
  end

  describe '.generate' do
    let(:org_alias) { :dev }
    let(:generator) { instance_double('SfCli::Sf::Model::Generator') }
    let(:object_names) { %w[Account Contact] }

    before do
      SfCli::Sf::Model.set_connection connection
    end

    it 'generates model classes' do
      allow(SfCli::Sf::Model::Generator).to receive(:new).with(connection).and_return(generator)
      allow(generator).to receive(:generate).with(object_names.first)
      allow(generator).to receive(:generate).with(object_names.last)

      SfCli::Sf::Model.generate object_names

      expect(SfCli::Sf::Model::Generator).to have_received(:new)
      expect(generator).to have_received(:generate).twice
    end
  end
end
