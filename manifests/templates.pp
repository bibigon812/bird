# bird::templates
#
# This class manages all templates
#
# @summary Manages all templates
#
# @example
#   include bird::templates
class bird::templates (
  Hash $bgp,
) {
  require bird

  $bgp.each |String[1] $bgp_name, Hash $bgp_params| {
    bird::bgp { $bgp_name:
      type => 'template',
      *    => $bgp_params,
    }
  }
}
