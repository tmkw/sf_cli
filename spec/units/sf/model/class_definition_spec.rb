require_relative '../../../support/shared_examples/class_definition_examples'

RSpec.describe 'SfCli::Sf::Model::ClassDefinition' do
  it_should_behave_like 'Model Class Definition' do
    let(:schema_class) { SfCli::Sf::Sobject::Schema }
  end
end
