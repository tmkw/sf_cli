require 'sf_cli/sf/model/class_definition'

RSpec.describe 'SfCli::Sf::Model::ClassDefinition' do
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

  describe '#to_s' do
    it 'covers all field attributes' do
      definition = SfCli::Sf::Model::ClassDefinition.new(schema)

      ClassDefininitionTest1= instance_eval(definition.to_s)

      obj = ClassDefininitionTest1.new

      expect(obj.methods).to include :Id
      expect(obj.methods).to include :Name
    end

    context 'the schema has parent relationships' do
      before do
        # generate the parent object class first
        parent_definition = SfCli::Sf::Model::ClassDefinition.new(parent_schema)
        ParentClassDefininitionTest1 = instance_eval(parent_definition.to_s)

        parent_obj = ParentClassDefininitionTest1.new
        expect(parent_obj.methods).to include :Id
        expect(parent_obj.methods).to include :ParentName
      end

      it 'covers parent relationships' do
        definition = SfCli::Sf::Model::ClassDefinition.new(schema_with_parent_relation)
        ClassDefininitionTest2 = instance_eval(definition.to_s)

        obj = ClassDefininitionTest2.new :Id => "hoge", :Name => "test", :Parent => {:Id => "bar", :ParentName => "this is Parent"}
        expect(obj.Id).to eq 'hoge'
        expect(obj.Name).to eq 'test'
        expect(obj.Parent.Id).to eq 'bar'
        expect(obj.Parent.ParentName).to eq 'this is Parent'
      end
    end

    context 'the schema has children relationships' do
      before do
        # generate the child object class first
        child_definition = SfCli::Sf::Model::ClassDefinition.new(child_schema)
        ChildClassDefininitionTest1 = instance_eval(child_definition.to_s)

        child_obj = ChildClassDefininitionTest1.new
        expect(child_obj.methods).to include :Id
        expect(child_obj.methods).to include :ChildName
      end

      it 'covers children relationships' do
        definition = SfCli::Sf::Model::ClassDefinition.new(schema_with_children_relation)
        ClassDefininitionTest3 = instance_eval(definition.to_s)

        obj = ClassDefininitionTest3.new(
          :Id => "hoge",
          :Name => "test",
          :Children => [
            {:Id => "bar1", :ChildName => "this is Child1"},
            {:Id => "bar2", :ChildName => "this is Child2"}
          ])

        expect(obj.Id).to eq 'hoge'
        expect(obj.Name).to eq 'test'
        expect(obj.Children.size).to be 2
        expect(obj.Children).to contain_exactly(
          an_object_having_attributes(:Id => 'bar1', :ChildName => 'this is Child1'),
          an_object_having_attributes(:Id => 'bar2', :ChildName => 'this is Child2')
        )
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
