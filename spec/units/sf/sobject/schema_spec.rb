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

  describe '#fields' do
    it 'contains all field data' do
      expect(schema.fields).to contain_exactly(
        an_instance_of(SfCli::Sf::Sobject::Schema::Field),
        an_instance_of(SfCli::Sf::Sobject::Schema::Field)
      )
      expect(schema.fields.to_a.first.name).to eq 'Id'
      expect(schema.fields.to_a.first.label).to eq 'Id Label'
      expect(schema.fields.to_a.last.name).to eq 'Name'
      expect(schema.fields.to_a.last.label).to eq 'Name Label'
    end
  end

  describe '#field_names' do
    it 'contains all field names' do
      expect(schema.field_names).to contain_exactly(:Id, :Name)
    end
  end

  describe '#field_labels' do
    it 'contains all field names' do
      expect(schema.field_labels).to contain_exactly('Id Label', 'Name Label')
    end
  end

  describe '#to_h' do
    it 'returns its schema definition as a Hash' do
      expect(schema.to_h).to eq schema_definition
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

  describe 'Fields' do
    describe '#name_and_labels' do
      it do
        expect(schema.fields.name_and_labels).to contain_exactly(
          ["Id", "Id Label"],
          ["Name", "Name Label"]
        )
      end
    end

    describe '#find_by' do
      it 'finds a field metadata by name' do
        field = schema.fields.find_by name: :Name
        expect(field.label).to eq 'Name Label'
        expect(field.name).to eq 'Name'
        expect(field.type).to eq 'string'
      end

      example 'finding by label' do
        field = schema.fields.find_by label: "Id Label"
        expect(field.label).to eq 'Id Label'
        expect(field.name).to eq 'Id'
        expect(field.type).to eq 'id'
      end
    end
  end

  def schema_definition
    {
      "name" => 'Hoge__c',
      "label" => 'Label of Hoge__c',
      "custom" => true,
      "childRelationships" => [],
      "fields" => [
        { "label"=>"Id Label",   "name"=>"Id",   "referenceTo"=>[], "relationshipName"=>nil, "type"=>"id" },
        { "label"=>"Name Label", "name"=>"Name", "referenceTo"=>[], "relationshipName"=>nil, "type"=>"string" },
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
