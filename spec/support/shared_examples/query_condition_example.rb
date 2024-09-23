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
