# bird::protocols
#
# This class manages all protocols
#
# @summary Manages all protocols
#
# @example
#   include bird::protocols
class bird::protocols (
  Hash $bgp,
) {
  $bgp.each |String[1] $bgp_name, Hash $bgp_params| {
    bird::bgp { $bgp_name:
      conf_path => $bird::conf_path,
      type      => 'protocol',
      *         => $bgp_params,
    }
  }
}
