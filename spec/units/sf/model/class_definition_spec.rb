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
