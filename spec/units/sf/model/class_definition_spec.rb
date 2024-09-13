RSpec.describe 'SfCli::Sf::Model::ClassDefinition', :model_definition do
  describe '.field_names' do
    it 'contains all field names' do
      definition = SfCli::Sf::Model::ClassDefinition.new(schema)
      expect(definition.schema.field_names).to contain_exactly(:Id, :Name)
    end
  end

  describe '.parent_relations' do
    it 'contains all parent relations' do
      definition = SfCli::Sf::Model::ClassDefinition.new(schema_with_parent_relation)
      expect(definition.schema.parent_relations).to contain_exactly(
        hash_including(name: :Parent, class_name: :ParentClassDefininitionTest1)
      )
    end
  end

  describe '.children_relations' do
    it 'contains all parent relations' do
      definition = SfCli::Sf::Model::ClassDefinition.new(schema_with_children_relation)
      expect(definition.schema.children_relations).to contain_exactly(
        hash_including(name: :Children, class_name: :ChildClassDefininitionTest1)
      )
    end
  end

  describe 'Model Class Definition' do
    it_should_behave_like 'generating Model Class Definitions' do
      let(:connection) { instance_double('SfCli::Sf::Model::SfCommandConnection') }
    end
  end


  describe 'model methods' do
    let(:connection) { double('Connection Adapter') }
    let(:model_instance) { double('model instance') }

    describe '.create' do
      let(:values) { {a: 100, b: 200} }

      before do
        definition = SfCli::Sf::Model::ClassDefinition.new(schema)
        ClassDefininitionTest4 = instance_eval(definition.to_s)
        ClassDefininitionTest4.connection = connection
        allow(connection).to receive(:create).with(:ClassDefininitionTest4, values, ClassDefininitionTest4).and_return(model_instance)
      end

      it 'create a record of the model' do
        expect(ClassDefininitionTest4.create values).to eq model_instance
        expect(connection).to have_received :create
      end
    end

    describe '.take' do
      let(:id) { anything }

      before do
        definition = SfCli::Sf::Model::ClassDefinition.new(schema)
        ClassDefininitionTest5 = instance_eval(definition.to_s)
        ClassDefininitionTest5.connection = connection
        allow(connection).to receive(:take).with(:ClassDefininitionTest5, id, ClassDefininitionTest5).and_return(model_instance)
      end

      it 'create a record of the model' do
        expect(ClassDefininitionTest5.take id).to eq model_instance
        expect(connection).to have_received :take
      end
    end
  end

  def schema
    {
      "Name" => 'Hoge__c',
      "custom" => true,
      "childRelationships" => [],
      "fields" => [
        { "label"=>"ID",   "name"=>"Id",   "referenceTo"=>[], "relationshipName"=>nil, "type"=>"id" },
        { "label"=>"Name", "name"=>"Name", "referenceTo"=>[], "relationshipName"=>nil, "type"=>"string" },
      ]
    }
  end

  def parent_schema
    {
      "Name" => 'Bar__c',
      "custom" => true,
      "childRelationships" => [],
      "fields" => [
        { "label"=>"ID",   "name"=>"Id",   "referenceTo"=>[], "relationshipName"=>nil, "type"=>"id" },
        { "label"=>"Name", "name"=>"ParentName", "referenceTo"=>[], "relationshipName"=>nil, "type"=>"string" },
      ]
    }
  end

  def child_schema
    {
      "Name" => 'Foo__c',
      "custom" => true,
      "childRelationships" => [],
      "fields" => [
        { "label"=>"ID",   "name"=>"Id",   "referenceTo"=>[], "relationshipName"=>nil, "type"=>"id" },
        { "label"=>"Name", "name"=>"ChildName", "referenceTo"=>[], "relationshipName"=>nil, "type"=>"string" },
      ]
    }
  end

  def schema_with_parent_relation
    {
      "Name" => 'Hoge__c',
      "custom" => true,
      "childRelationships" => [],
      "fields" => [
        { "label"=>"ID",   "name"=>"Id",   "referenceTo"=>[], "relationshipName"=>nil, "type"=>"id" },
        { "label"=>"Name", "name"=>"Name", "referenceTo"=>[], "relationshipName"=>nil, "type"=>"string" },
        { "label"=>"Name", "name"=>"ParentId", "referenceTo"=>["ParentClassDefininitionTest1"], "relationshipName"=>"Parent", "type"=>"string" },
      ]
    }
  end

  def schema_with_children_relation
    {
      "Name" => 'Hoge__c',
      "custom" => true,
      "childRelationships" => [
        {
          "childSObject"=>"AIInsightValue",
          "field"=>"SobjectLookupValueId",
          "relationshipName"=>nil,
        },
        {
          "childSObject"=>"ChildClassDefininitionTest1",
          "field"=>"TargetId",
          "relationshipName"=>"Children",
        }
      ],
      "fields" => [
        { "label"=>"ID",   "name"=>"Id",   "referenceTo"=>[], "relationshipName"=>nil, "type"=>"id" },
        { "label"=>"Name", "name"=>"Name", "referenceTo"=>[], "relationshipName"=>nil, "type"=>"string" },
      ]
    }
  end
end
