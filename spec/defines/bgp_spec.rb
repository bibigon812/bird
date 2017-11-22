require 'spec_helper'

describe 'bird::bgp' do
  let(:pre_condition) { 'include bird' }

  let(:title) { 'namevar' }

  let(:params) do
    {
      'conf_path' => '/etc/bird.conf',
      'local_as'  => 65000,
      'remote_ip' => '10.0.0.2',
    }
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it {
        is_expected.to contain_concat__fragment('bird_conf_50_bgp_namevar')
          .with_content(<<-EOS

protocol bgp namevar {
    local as 65000
    neighbor 10.0.0.2

    export none
    import all
}
EOS
          )
      }

      context "with remote_as => 65000" do
        let(:params) {
          super().merge({ 'remote_as' => 65000 })
        }

        it {
          is_expected.to contain_concat__fragment('bird_conf_50_bgp_namevar')
            .with_content(<<-EOS

protocol bgp namevar {
    local as 65000
    neighbor as 65000
    neighbor 10.0.0.2

    export none
    import all
}
EOS
            )
        }
      end
    end
  end
end
