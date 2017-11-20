# bird::filter
#
# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   bird::filter { 'namevar':
#     conf_path => '/etc/bird.conf',
#     body      => @("EOT")
#                  {
#                    if defined(rip_metric) then
#                      var = rip_metric;
#                    else {
#                      var = 1;
#                      rip_metric = 1;
#                    }
#                    if rip_metric > 10 then
#                      reject "RIP metric is too big";
#                    else
#                      accept "OK";
#                  }
#                  |- EOT
#   }
#
# @param
#   conf_path
#     Specifies the configuration file.
#
# @param
#   body
#     ...
#
# @param
#   defines
#     ...
#
# @params
#   variables
#     ...
#
define bird::filter (
  Stdlib::Absolutepath $conf_path,

  String[1] $body,
  Array[Struct[{
    name  => String[1],
    value => Variant[Integer, String[1]],
  }]] $defines = [],
  Array[Struct[{
    name => String[1],
    type => Pattern[/\A(int|pair|quad|ip|prefix|ec|lc|enum)(?:\sset)?\Z/],
    value => Variant[Integer, String[1]],
  }]] $variables = [],
) {

  concat::fragment { "bird_conf_20_filter_${name}":
    content => epp('bird/filter.conf.epp', {
      name      => $name,
      body      => strip($body),
      defines   => $defines,
      variables => $variables,
    }),
    order   => 20,
    target  => $conf_path,
  }
}
