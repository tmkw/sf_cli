require 'sf_cli/sf/model'

RSpec.describe 'SfCli::Sf::Model' do
  describe '.generate' do
    let(:org_alias) { :dev }
    let(:connection) { double('Connection Object', target_org: org_alias) }
    let(:generator) { instance_double('SfCli::Sf::Model::Generator') }
    let(:object_names) { %w[Account Contact] }

    before do
      allow(SfCli::Sf::Model::Generator).to receive(:new).with(connection).and_return(generator)
    end

    it 'generates model classes' do
      allow(generator).to receive(:generate).with(object_names.first)
      allow(generator).to receive(:generate).with(object_names.last)

      SfCli::Sf::Model.generate connection, object_names

      expect(SfCli::Sf::Model::Generator).to have_received(:new)
      expect(generator).to have_received(:generate).twice
    end
  end
end
