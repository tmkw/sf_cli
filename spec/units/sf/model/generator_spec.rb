require 'sf_cli/sf/model/class_definition'
require_relative '../../../support/shared_examples/generator_examples'

RSpec.describe 'SfCli::Sf::Model::Generator' do
  let(:org_alias)         { :dev }
  let(:class_definition)  { instance_double('SfCli::Sf::Model::ClassDefinition') }
  let(:schema)            { anything }
  let(:class_expression)  { 'Class.new{def self.connection=(conn); @con = conn; end; def self.connection; @con; end}' }
  let(:object_name)       { 'ModelGeneratorTestClass' }

  before do
    allow(SfCli::Sf::Model::ClassDefinition).to receive(:new).with(schema).and_return(class_definition)
  end

  describe '#generate' do
    it_should_behave_like 'Generator#generate' do
      let(:connection) { instance_double('SfCli::Sf::Model::SfCommandConnection') }
    end
  end
end
