# bird::bgp
#
# This defined resource manages the bgp neighbor configuration
#
# @summary Manages the bgp protocol or template configuration
#
# @example
#   bird::bgp { 'namevar': }
# @param confd_path Specifies the directiry for partial configuration falies
# @param local_as Contains a local AS number
# @param remote_as Contains a neighbor AS number
# @param remote_ip Contains a neighbor IP address
# @param remote_port Contains a neighbor port number
# @param type Specifies 'template' or 'protocol'
# @param update_source Specifies a source IP address for updates
#
define bird::bgp (
  Stdlib::Absolutepath $confd_path,
  Integer[1] $local_as,
  Stdlib::Compat::Ipv4 $remote_ip,

  Enum['absent', 'present'] $ensure = 'present',
  Enum['protocol', 'template'] $type = 'protocol',

  Optional[Stdlib::Compat::Ipv4] $update_source = undef,
  Optional[Integer[1]] $remote_as = undef,
  Optional[Integer[1, 65535]] $remote_port = undef,
) {

  $file_name = $type ? {
    'protocol' => "${confd_path}/protocol_bgp_${name}.conf",
    default    => "${confd_path}/template_bgp_${name}.conf",
  }

  file { $file_name:
    ensure  => $ensure,
    content => epp('bird/bgp.conf.epp', {
      name          => $name,
      local_as      => $local_as,
      remote_as     => $remote_as,
      remote_ip     => $remote_ip,
      remote_port   => $remote_port,
      type          => $type,
      update_source => $update_source,
    }),
  }
}
