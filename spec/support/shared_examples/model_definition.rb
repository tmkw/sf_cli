RSpec.shared_examples 'generating Model Class Definitions' do
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

  describe 'model operation methods' do
    let(:id) { anything }
    let(:model_instance) { double('model instance') }

    describe '.create' do
      let(:values) { {a: 100, b: 200} }

      before do
        definition = SfCli::Sf::Model::ClassDefinition.new(schema)
        ClassDefininitionTest4 = instance_eval(definition.to_s)
        ClassDefininitionTest4.connection = connection
      end

      it 'create a record of the model' do
        allow(connection).to receive(:create).with(:ClassDefininitionTest4, values, ClassDefininitionTest4).and_return(model_instance)

        expect(ClassDefininitionTest4.create values).to eq model_instance
        expect(connection).to have_received :create
      end
    end

    describe '.take' do
      before do
        definition = SfCli::Sf::Model::ClassDefinition.new(schema)
        ClassDefininitionTest5 = instance_eval(definition.to_s)
        ClassDefininitionTest5.connection = connection
        allow(connection).to receive(:take).with(:ClassDefininitionTest5, id, ClassDefininitionTest5).and_return(model_instance)
      end

      it 'get a record of the model' do
        expect(ClassDefininitionTest5.take id).to eq model_instance
        expect(connection).to have_received :take
      end
    end

    describe '#save' do
      it "save a new record" do
        definition = SfCli::Sf::Model::ClassDefinition.new(schema)
        ClassDefininitionTest6 = instance_eval(definition.to_s)
        ClassDefininitionTest6.connection = connection


        allow(connection).to receive(:create).with(:ClassDefininitionTest6, {Name: 'Hoge Fuga'}).and_return(id)

        obj = ClassDefininitionTest6.new(:Name => "Hoge Fuga")
        expect(obj.save).to eq id

        expect(connection).to have_received :create
      end

      it "update a record, which already exists" do
        definition = SfCli::Sf::Model::ClassDefinition.new(schema)
        ClassDefininitionTest7 = instance_eval(definition.to_s)
        ClassDefininitionTest7.connection = connection

        allow(connection).to receive(:update).with(:ClassDefininitionTest7, id, nil, {Name: 'Foo Baz'}).and_return(id)

        obj = ClassDefininitionTest7.new(:Id => id, :Name => "Hoge Fuga")
        obj.Name = "Foo Baz"
        expect(obj.save).to eq id

        expect(connection).to have_received :update
      end
    end

    describe '#delete' do
      it "delete a record" do
        definition = SfCli::Sf::Model::ClassDefinition.new(schema)
        ClassDefininitionTest8 = instance_eval(definition.to_s)
        ClassDefininitionTest8.connection = connection

        allow(connection).to receive(:delete).with(:ClassDefininitionTest8, id).and_return(id)

        obj = ClassDefininitionTest8.new(:Id => id, :Name => "Hoge Fuga")
        expect(obj.delete).to eq id

        expect(connection).to have_received :delete
      end
    end
  end
end
