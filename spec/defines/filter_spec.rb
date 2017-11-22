require 'spec_helper'

describe 'bird::filter' do
  let(:pre_condition) { 'include bird' }

  let(:title) { 'namevar' }

  let(:body) do
    <<-BODY
{
  if defined(rip_metric) then
    var = rip_metric;
  else {
    var = 1;
    rip_metric = 1;
  }
  if rip_metric > 10 then
    reject "RIP metric is too big";
  else
    accept "OK";
}
BODY
  end

  let(:params) do
    {
      'conf_path' => '/etc/bird.conf',
      'body'      => body,
      'defines'   => {
        'am' => '[= 65000 65000 =]',
      },
      'variables' => {
        'ps'   => 'pair set',
        'odds' => 'int set',
      },
    }
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it do
        is_expected.to contain_concat__fragment('bird_conf_20_filter_namevar')
          .with_content(<<-EOS

filter namevar
define am = [= 65000 65000 =];
pair set ps;
int set odds;
{
  if defined(rip_metric) then
    var = rip_metric;
  else {
    var = 1;
    rip_metric = 1;
  }
  if rip_metric > 10 then
    reject "RIP metric is too big";
  else
    accept "OK";
}
EOS
          )
      end
    end
  end
end
