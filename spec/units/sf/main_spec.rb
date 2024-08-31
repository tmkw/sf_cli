RSpec.describe 'SfCli::Sf::Main' do
  let(:sf) { SfCli::Sf::Main.instance }

  it "has a getter method 'org' for 'sf org' operation" do
    expect(sf.methods).to include :org
  end

  it "has a getter method 'data' for 'sf data' operation" do
    expect(sf.methods).to include :data
  end

  it "has a getter method 'sobject' for 'sf sobject' operation" do
    expect(sf.methods).to include :sobject
  end

  it "has a getter method 'project' for 'sf project' operation" do
    expect(sf.methods).to include :project
  end
end
