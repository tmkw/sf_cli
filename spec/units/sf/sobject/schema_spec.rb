require 'sf_cli/sf/sobject/schema'

RSpec.describe 'SfCli::Sf::Sobject::Schema' do
  let(:schema){ SfCli::Sf::Sobject::Schema.new(schema_definition) }

  describe '#name' do
    it 'shows its name' do
      expect(schema.name).to eq 'Hoge__c'
    end
  end

  describe '#label' do
    it 'shows its label' do
      expect(schema.label).to eq 'Label of Hoge__c'
    end
  end

  describe '#field_names' do
    it 'contains all field names' do
      expect(schema.field_names).to contain_exactly(:Id, :Name)
    end
  end

  describe '#fields[]' do
    it 'returns field information' do
      expect(schema.fields[:Name]).to include(
        "label"=>"Name",
        "name"=>"Name",
        "referenceTo"=>[],
        "relationshipName"=>nil,
        "type"=>"string"
      )
    end
  end

  describe '#all' do
    it 'returns its schema definition' do
      expect(schema.all).to eq schema_definition
    end
  end

  describe '#parent_relations' do
    let(:schema){ SfCli::Sf::Sobject::Schema.new(schema_definition_with_parent_relation) }

    it 'contains all parent relations' do
      expect(schema.parent_relations).to contain_exactly(
        hash_including(name: :Parent, field: :ParentId, class_name: :ParentClassDefininitionTest1)
      )
    end
  end

  describe '#children_relations' do
    let(:schema){ SfCli::Sf::Sobject::Schema.new(schema_definition_with_children_relation) }

    it 'contains all parent relations' do
      expect(schema.children_relations).to contain_exactly(
        hash_including(name: :Children, field: :TargetId, class_name: :ChildClassDefininitionTest1)
      )
    end
  end

  def schema_definition
    {
      "name" => 'Hoge__c',
      "label" => 'Label of Hoge__c',
      "custom" => true,
      "childRelationships" => [],
      "fields" => [
        { "label"=>"ID",   "name"=>"Id",   "referenceTo"=>[], "relationshipName"=>nil, "type"=>"id" },
        { "label"=>"Name", "name"=>"Name", "referenceTo"=>[], "relationshipName"=>nil, "type"=>"string" },
      ]
    }
  end

  def schema_definition_with_parent_relation
    {
      "name" => 'Hoge__c',
      "custom" => true,
      "childRelationships" => [],
      "fields" => [
        { "label"=>"ID",   "name"=>"Id",   "referenceTo"=>[], "relationshipName"=>nil, "type"=>"id" },
        { "label"=>"Name", "name"=>"Name", "referenceTo"=>[], "relationshipName"=>nil, "type"=>"string" },
        { "label"=>"Name", "name"=>"ParentId", "referenceTo"=>["ParentClassDefininitionTest1"], "relationshipName"=>"Parent", "type"=>"string" },
      ]
    }
  end

  def schema_definition_with_children_relation
    {
      "name" => 'Hoge__c',
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