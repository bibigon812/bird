require 'spec_helper'

describe 'bird::global' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include bird' }

      it { is_expected.to compile }

      context "with minimal params" do

        it {
          is_expected.to contain_concat__fragment('bird_conf_10_global')
            .with_content(<<-EOS
#
# Managed by Puppet in the rp_env environment
#

router id 172.16.254.254
EOS
            )
        }
      end
    end
  end
end
