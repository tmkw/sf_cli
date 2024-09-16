RSpec.shared_examples 'defining model DML methods' do
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

      allow(connection).to receive(:update).with(:ClassDefininitionTest7, id, {Name: 'Foo Baz'}).and_return(id)

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
