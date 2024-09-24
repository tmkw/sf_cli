RSpec.shared_examples 'QueryCondition#all' do
  let(:query_condition) { SfCli::Sf::Model::QueryMethods::QueryCondition.new(connection, klass.name, field_names) }
  let(:soql) { "SELECT Id, Name FROM Object" }
  let(:result) { [anything, anything] }

  before do
    allow(query_condition).to receive(:to_soql).and_return(soql)
    allow(connection).to receive(:query).with(soql, klass).and_return(result)
  end

  it 'returns records that match the query condtions' do
    expect(query_condition.all).to be result

    expect(query_condition).to have_received :to_soql
    expect(connection).to have_received :query
  end
end

RSpec.shared_examples 'QueryCondition#to_csv' do
  let(:query_condition) { SfCli::Sf::Model::QueryMethods::QueryCondition.new(connection, klass.name, field_names) }
  let(:soql) { "SELECT Id, Name FROM Object" }
  let(:csv) { 'CSV contents' }

  before do
    allow(query_condition).to receive(:to_soql).and_return(soql)
    allow(connection).to receive(:query).with(soql, klass, :csv).and_return(csv)
  end

  it 'returns records that match the query condtions' do
    expect(query_condition.to_csv).to be csv

    expect(query_condition).to have_received :to_soql
    expect(connection).to have_received :query
  end
end

RSpec.shared_examples 'QueryCondition#pluck' do
  let(:query_condition) { SfCli::Sf::Model::QueryMethods::QueryCondition.new(connection, klass.name, field_names) }
  let(:soql) { "SELECT Id, Name FROM Object" }
  let(:rows) { [{'a' => 'abc', 'b' => 'def'}, {'a' => 'uvw', 'b' => 'xyz'}] }
  let(:result) { ['abc', 'uvw'] }

  before do
    allow(query_condition).to receive(:to_soql).and_return(soql)
    allow(connection).to receive(:query).with(soql, nil).and_return(rows)
  end

  it 'returns records that match the query condtions' do
    expect(query_condition.pluck :a).to eq result

    expect(query_condition).to have_received :to_soql
    expect(connection).to have_received :query
  end
end

RSpec.shared_examples 'QueryCondition#count' do
  let(:query_condition) { SfCli::Sf::Model::QueryMethods::QueryCondition.new(connection, klass.name, field_names) }
  let(:soql) { "SELECT COUNT(Id) FROM #{klass.name}" }
  let(:rows) { [{'expr0' => 3}] }
  let(:result) { 3 }

  before do
    allow(connection).to receive(:query).with(soql, nil).and_return(rows)
  end

  it 'returns record count that match the query condtions' do
    expect(query_condition.count).to eq result
    expect(connection).to have_received :query
  end
end

RSpec.shared_examples 'QueryCondition#min' do
  let(:query_condition) { SfCli::Sf::Model::QueryMethods::QueryCondition.new(connection, klass.name, field_names) }
  let(:soql) { "SELECT MIN(LastModifiedDate) FROM #{klass.name}" }
  let(:rows) { [{'expr0' => '2024-09-24T13:46:00.000+0000'}] }
  let(:result) { '2024-09-24T13:46:00.000+0000' }

  before do
    allow(connection).to receive(:query).with(soql, nil).and_return(rows)
  end

  it 'returns record count that match the query condtions' do
    expect(query_condition.min(:LastModifiedDate)).to eq result
    expect(connection).to have_received :query
  end
end

RSpec.shared_examples 'QueryCondition#max' do
  let(:query_condition) { SfCli::Sf::Model::QueryMethods::QueryCondition.new(connection, klass.name, field_names) }
  let(:soql) { "SELECT MAX(LastModifiedDate) FROM #{klass.name}" }
  let(:rows) { [{'expr0' => '2024-09-24T13:46:00.000+0000'}] }
  let(:result) { '2024-09-24T13:46:00.000+0000' }

  before do
    allow(connection).to receive(:query).with(soql, nil).and_return(rows)
  end

  it 'returns record count that match the query condtions' do
    expect(query_condition.max(:LastModifiedDate)).to eq result
    expect(connection).to have_received :query
  end
end
