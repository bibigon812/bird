require 'spec_helper'

describe 'bird::templates' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include bird' }

      it { is_expected.to compile }
    end
  end
end
