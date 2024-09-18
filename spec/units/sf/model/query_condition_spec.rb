require_relative '../../../support/shared_examples/query_condition_example'

RSpec.describe 'SfCli::Sf::Model::QueryMethods::QueryCondition' do
  QueryContditionTestClass = Struct.new(:a, :b)

  let(:query_condition) { SfCli::Sf::Model::QueryMethods::QueryCondition.new(connection, klass.name, field_names) }
  let(:field_names) { [anything, anything] }
  let(:connection) { double('Some kind of Connection') }
  let(:klass) { QueryContditionTestClass }

  describe '#all' do
    it_should_behave_like 'QueryCondition#all' do
      let(:connection) { instance_double('SfCli::Sf::Model::SfCommandConnection') }
    end
  end

  describe '#pluck' do
    let(:row1) { QueryContditionTestClass.new(a: 'abc', b: 'def') }
    let(:row2) { QueryContditionTestClass.new(a: 'uvw', b: 'xyz') }
    let(:rows) { [row1, row2] }

    before do
      allow(query_condition).to receive(:all).and_return(rows)
    end

    it "returns a values of paticular field" do
      expect(query_condition.pluck(:a)).to eq ['abc', 'uvw']
      expect(query_condition).to have_received :all
    end
  end

  describe '#take' do
    let(:row1) { QueryContditionTestClass.new(a: 'abc', b: 'def') }
    let(:row2) { QueryContditionTestClass.new(a: 'uvw', b: 'xyz') }
    let(:rows) { [row1, row2] }

    before do
      allow(query_condition).to receive(:limit).with(1).and_return(query_condition)
      allow(query_condition).to receive(:all).and_return(rows)
    end

    it "returns a values of paticular field" do
      expect(query_condition.take).to eq row1
      expect(query_condition).to have_received :limit
      expect(query_condition).to have_received :all
    end
  end

  describe '#where' do
    example 'Hash Style' do
      expect(query_condition.where(Name: 'Hoge Fuga')).to be query_condition
      expect(query_condition.conditions).to contain_exactly(["Name = 'Hoge Fuga'"])
    end

    example 'Hash Style (2)' do
      expect(query_condition.where(Name: 'Hoge Fuga', Age: 32)).to be query_condition
      expect(query_condition.conditions).to contain_exactly(["Name = 'Hoge Fuga'", "Age = 32"])
    end

    example 'Raw SOQL Style' do
      expect(query_condition.where("Name = 'Hoge Fuga' AND Age = 32")).to be query_condition
      expect(query_condition.conditions).to contain_exactly("Name = 'Hoge Fuga' AND Age = 32")
    end

    example 'Ternary Style' do
      expect(query_condition.where(:Name, :Like, '%Hoge%')).to be query_condition
      expect(query_condition.conditions).to contain_exactly("Name Like '%Hoge%'")
    end

    it 'stacks conditions' do
      query_condition
        .where(Name: 'Hoge Fuga', Age: 32)
        .where("Name = 'Hoge Fuga' AND Age = 32")
        .where(:Name, :Like, '%Hoge%')

      expect(query_condition.conditions).to contain_exactly(
        ["Name = 'Hoge Fuga'", "Age = 32"],
        "Name = 'Hoge Fuga' AND Age = 32",
        "Name Like '%Hoge%'"
      )
    end

    context 'empty input' do
      it 'just returns itself' do
        expect(query_condition.where()).to be query_condition
        expect(query_condition.where({})).to be query_condition
        expect(query_condition.where('')).to be query_condition
        expect(query_condition.conditions.size).to be 0
      end
    end

    context 'invalid input' do
      it 'just returns itself' do
        expect(query_condition.where(100)).to be query_condition
        expect(query_condition.conditions.size).to be 0
      end
    end
  end

  describe '#select' do
    example 'set a field' do
      expect(query_condition.select(:Name)).to be query_condition
      expect(query_condition.fields).to contain_exactly(:Name)
    end

    example 'set fields' do
      expect(query_condition.select(:Name, :Age, :Phone)).to be query_condition
      expect(query_condition.fields).to contain_exactly(:Name, :Age, :Phone)
    end

    context 'no input' do
      it 'just returns itself' do
        expect(query_condition.select()).to be query_condition
        expect(query_condition.fields).to eq []
      end
    end
  end

  describe '#limit' do
    it 'sets record number limit' do
      expect(query_condition.limit(5)).to be query_condition
      expect(query_condition.limit_num).to be 5
    end
  end

  describe '#order' do
    example 'setting a record order key' do
      expect(query_condition.order(:Name)).to be query_condition
      expect(query_condition.row_order).to eq [:Name]
    end

    example 'setting a record order key' do
      expect(query_condition.order(:Name, :Age)).to be query_condition
      expect(query_condition.row_order).to eq [:Name, :Age]
    end

    example 'no input' do
      expect(query_condition.order).to be query_condition
      expect(query_condition.row_order).to be nil
    end
  end

  describe '#to_soql' do
    it 'constructs a soql' do
      query_condition
        .where(Name: 'John Smith', Age: 34)
        .where(Phone: '090-xxxx-xxxx')
        .where(Country: ['Japan', 'USA', 'China'])
        .where("ContactId IN ('a','b')")
        .where(:GroupName, :LIKE, '%abc%')
        .where(:LastModifiedDate, :>=, :"LAST_N_DAYS:90")
        .select(:Id, :Name, :"Account.Name", "(SELECT Name FROM Accounts)")
        .limit(30)
        .order(:Country, :Name)
      expect(query_condition.to_soql).to eq "SELECT Id, Name, Account.Name, (SELECT Name FROM Accounts) FROM QueryContditionTestClass WHERE Name = 'John Smith' AND Age = 34 AND Phone = '090-xxxx-xxxx' AND Country IN ('Japan', 'USA', 'China') AND ContactId IN ('a','b') AND GroupName LIKE '%abc%' AND LastModifiedDate >= LAST_N_DAYS:90 ORDER BY Country, Name LIMIT 30"
    end
  end
end
