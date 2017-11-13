require 'spec_helper'

describe 'bird::protocols::bpg' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      config_path: '/etc/bird.conf',
      local_as: 65000,
      remote_ip: '10.0.0.2',
    }
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
