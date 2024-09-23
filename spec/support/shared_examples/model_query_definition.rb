RSpec.shared_examples 'defining model Query methods' do
  let(:id) { anything }
  let(:model_instance) { double('model instance') }
  let(:definition) { SfCli::Sf::Model::ClassDefinition.new(schema) }
  let(:query_condition) { instance_double('SfCli::Sf::Model::QueryMethods::QueryCondition')  }

  describe '.select' do
    before do
      ClassDefininitionTest102 = instance_eval(definition.to_s)
      ClassDefininitionTest102.connection = connection

      allow(SfCli::Sf::Model::QueryMethods::QueryCondition)
        .to receive(:new)
        .with(connection, 'ClassDefininitionTest102', ClassDefininitionTest102.field_names)
        .and_return(query_condition)

      allow(query_condition).to receive(:select).with(:Id, :Name)
    end

    it 'returns a QueryCondition object' do
      expect(ClassDefininitionTest102.select :Id, :Name).to be query_condition

      expect(SfCli::Sf::Model::QueryMethods::QueryCondition).to have_received :new
      expect(query_condition).to have_received :select
    end
  end

  describe '.where' do
    it 'returns a QueryCondition object' do
      ClassDefininitionTest103 = instance_eval(definition.to_s)
      ClassDefininitionTest103.connection = connection

      allow(SfCli::Sf::Model::QueryMethods::QueryCondition)
        .to receive(:new)
        .with(connection, 'ClassDefininitionTest103', ClassDefininitionTest103.field_names)
        .and_return(query_condition)

      allow(query_condition).to receive(:where).with({Name: 'John', Age: 34})

      expect(ClassDefininitionTest103.where Name: 'John', Age: 34).to be query_condition

      expect(SfCli::Sf::Model::QueryMethods::QueryCondition).to have_received :new
      expect(query_condition).to have_received :where
    end

    example 'raw string style' do
      ClassDefininitionTest104 = instance_eval(definition.to_s)
      ClassDefininitionTest104.connection = connection

      allow(SfCli::Sf::Model::QueryMethods::QueryCondition)
        .to receive(:new)
        .with(connection, 'ClassDefininitionTest104', ClassDefininitionTest104.field_names)
        .and_return(query_condition)

      allow(query_condition).to receive(:where).with("Name = 'John' AND Age = 34")

      expect(ClassDefininitionTest104.where "Name = 'John' AND Age = 34").to be query_condition

      expect(SfCli::Sf::Model::QueryMethods::QueryCondition).to have_received :new
      expect(query_condition).to have_received :where
    end

    example 'ternary style' do
      ClassDefininitionTest105 = instance_eval(definition.to_s)
      ClassDefininitionTest105.connection = connection

      allow(SfCli::Sf::Model::QueryMethods::QueryCondition)
        .to receive(:new)
        .with(connection, 'ClassDefininitionTest105', ClassDefininitionTest105.field_names)
        .and_return(query_condition)

      allow(query_condition).to receive(:where).with(:Name, "=", 'John')

      expect(ClassDefininitionTest105.where :Name, "=",  'John').to be query_condition

      expect(SfCli::Sf::Model::QueryMethods::QueryCondition).to have_received :new
      expect(query_condition).to have_received :where
    end
  end

  describe '.limit' do
    before do
      ClassDefininitionTest106 = instance_eval(definition.to_s)
      ClassDefininitionTest106.connection = connection

      allow(SfCli::Sf::Model::QueryMethods::QueryCondition)
        .to receive(:new)
        .with(connection, 'ClassDefininitionTest106', ClassDefininitionTest106.field_names)
        .and_return(query_condition)

      allow(query_condition).to receive(:limit).with(5)
    end

    it 'returns a QueryCondition object' do
      expect(ClassDefininitionTest106.limit 5).to be query_condition

      expect(SfCli::Sf::Model::QueryMethods::QueryCondition).to have_received :new
      expect(query_condition).to have_received :limit
    end
  end

  describe '.order' do
    before do
      ClassDefininitionTest107 = instance_eval(definition.to_s)
      ClassDefininitionTest107.connection = connection

      allow(SfCli::Sf::Model::QueryMethods::QueryCondition)
        .to receive(:new)
        .with(connection, 'ClassDefininitionTest107', ClassDefininitionTest107.field_names)
        .and_return(query_condition)

      allow(query_condition).to receive(:order).with(:Name, :Age)
    end

    it 'returns a QueryCondition object' do
      expect(ClassDefininitionTest107.order :Name, :Age).to be query_condition

      expect(SfCli::Sf::Model::QueryMethods::QueryCondition).to have_received :new
      expect(query_condition).to have_received :order
    end
  end

  describe '.all' do
    let(:result) {[instance_double('ClassDefininitionTest108')]}

    before do
      ClassDefininitionTest108 = instance_eval(definition.to_s)
      ClassDefininitionTest108.connection = connection

      allow(SfCli::Sf::Model::QueryMethods::QueryCondition)
        .to receive(:new)
        .with(connection, 'ClassDefininitionTest108', ClassDefininitionTest108.field_names)
        .and_return(query_condition)

      allow(query_condition).to receive(:all).and_return(result)
    end
    it 'returns a rows of the model class object' do
      expect(ClassDefininitionTest108.all).to be result

      expect(SfCli::Sf::Model::QueryMethods::QueryCondition).to have_received :new
      expect(query_condition).to have_received :all
    end
  end

  describe '.pluck' do
    let(:result) {["Bar Hoge", "John Smith"]}

    before do
      ClassDefininitionTest109 = instance_eval(definition.to_s)
      ClassDefininitionTest109.connection = connection

      allow(SfCli::Sf::Model::QueryMethods::QueryCondition)
        .to receive(:new)
        .with(connection, 'ClassDefininitionTest109', ClassDefininitionTest109.field_names)
        .and_return(query_condition)

      allow(query_condition).to receive(:pluck).with(:Name).and_return(result)
    end

    it 'returns a rows of the model class object' do
      expect(ClassDefininitionTest109.pluck :Name).to be result

      expect(SfCli::Sf::Model::QueryMethods::QueryCondition).to have_received :new
      expect(query_condition).to have_received :pluck
    end
  end

  describe '.take' do
    let(:result) { instance_double('ClassDefininitionTest110') }

    before do
      ClassDefininitionTest110 = instance_eval(definition.to_s)
      ClassDefininitionTest110.connection = connection

      allow(SfCli::Sf::Model::QueryMethods::QueryCondition)
        .to receive(:new)
        .with(connection, 'ClassDefininitionTest110', ClassDefininitionTest110.field_names)
        .and_return(query_condition)

      allow(query_condition).to receive(:take).and_return(result)
    end

    it 'returns a rows of the model class object' do
      expect(ClassDefininitionTest110.take).to be result

      expect(SfCli::Sf::Model::QueryMethods::QueryCondition).to have_received :new
      expect(query_condition).to have_received :take
    end
  end

  describe '.find' do
    before do
      ClassDefininitionTest111 = instance_eval(definition.to_s)
      ClassDefininitionTest111.connection = connection
      allow(connection).to receive(:find).with(:ClassDefininitionTest111, id, ClassDefininitionTest111).and_return(model_instance)
    end

    it 'get a record of the model' do
      expect(ClassDefininitionTest111.find id).to eq model_instance
      expect(connection).to have_received :find
    end
  end

  describe '.find_by' do
    let(:result) { instance_double('ClassDefininitionTest112') }

    before do
      ClassDefininitionTest112 = instance_eval(definition.to_s)
      ClassDefininitionTest112.connection = connection

      allow(SfCli::Sf::Model::QueryMethods::QueryCondition)
        .to receive(:new)
        .with(connection, 'ClassDefininitionTest112', ClassDefininitionTest112.field_names)
        .and_return(query_condition)

      allow(query_condition).to receive(:where).with({Name: 'John Smith', Age: 33}).and_return(query_condition)
      allow(query_condition).to receive(:take).and_return(result)
    end

    it 'get a record according to search conditions' do
      expect(ClassDefininitionTest112.find_by Name: 'John Smith', Age: 33).to be result

      expect(SfCli::Sf::Model::QueryMethods::QueryCondition).to have_received :new
      expect(query_condition).to have_received :where
      expect(query_condition).to have_received :take
    end
  end
end
