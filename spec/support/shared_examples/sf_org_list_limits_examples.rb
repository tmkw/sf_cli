RSpec.shared_examples 'sf org list limits' do
  it "lists the limits in the org" do
    limits = subject
    expect(limits.names).to contain_exactly(
      'PermissionSets',
      'PrivateConnectOutboundCalloutHourlyLimitMB',
    )

    limit = limits.find :PermissionSets
    expect(limit.max).to eq 1500
    expect(limit.remaining).to eq 1498
  end
end
