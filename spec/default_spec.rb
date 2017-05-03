require 'spec_helper'

RSpec.describe 'alfresco-db::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '7.2.1511',
      file_cache_path: '/var/chef/cache'
    ) do |node|
    end.converge(described_recipe)
  end

  before do
    stub_command('getenforce | grep -i enforcing').and_return('')
  end

  it 'should include mysql_local as default recipe' do
    expect(chef_run).to include_recipe('alfresco-db::mysql_local')
  end
end
