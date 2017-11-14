require 'spec_helper'

describe 'bird::bgp' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'confd_path' => '/etc/bird.d',
      'local_as'   => 65000,
      'remote_ip'  => '10.0.0.2',
    }
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it { is_expected.to contain_file('/etc/bird.d/protocol_bgp_namevar.conf')}
    end
  end
end
