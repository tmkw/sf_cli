require 'sf_cli/sf/model/generator'
require 'sf_cli/sf/model/class_definition'

RSpec.describe 'SfCli::Sf::Model::Generator' do
  let(:org_alias)         { :dev }
  let(:connection)        { double('Connection Object', target_org: org_alias) }
  let(:sf_sobject)        { instance_double('SfCli::Sf::Sobject::Core') }
  let(:class_definition)  { instance_double('SfCli::Sf::Model::ClassDefinition') }
  let(:schema)            { anything }
  let(:object_name)       { 'Account' }
  let(:class_expression)  { 'Class.new{ def self.connection=(conn); @con = conn; end }' }
  let(:klass) { double('Account') }

  before do
    allow(SfCli::Sf::Sobject::Core).to receive(:new).and_return(sf_sobject)
    allow(SfCli::Sf::Model::ClassDefinition).to receive(:new).with(schema).and_return(class_definition)
  end

  describe '#generate' do
    before do
      allow(sf_sobject).to receive(:describe).with(object_name, target_org: org_alias).and_return(schema)
      allow(class_definition).to receive(:to_s).and_return(class_expression)
    end

    it 'generates a class' do
      generator = SfCli::Sf::Model::Generator.new(connection)

      allow(generator).to receive(:instance_eval).with("::#{object_name} = #{class_expression}")
      allow(Object).to receive(:const_get).with(object_name.to_sym).and_return(klass)
      allow(klass).to receive(:connection=).with(connection)

      generator.generate(object_name)

      expect(sf_sobject).to have_received :describe
      expect(class_definition).to have_received :to_s
      expect(generator).to have_received :instance_eval
      expect(klass).to have_received :connection=
    end
  end
end
