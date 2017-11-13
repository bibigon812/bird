# bird::protocol::bpg
#
# This type manages bgp sessions
#
# @summary Manages bgp sessions
#
# @example
#   bird::protocol::bpg { 'namevar': }
#
# BIRD: local [<ip>] as <number>
# @param local_as_number The local AS number
# @param update_source The source IP address
#
# BIRD: neighbor <ip> [port <number>] [as <number>]
# @param remote_as The neighbor AS number
# @param remote_ip The neighbor IP address
# @param remote_port The neighbor port number
define bird::protocols::bpg (
  Stdlib::Absolutepath $config_path,
  Integer[1] $local_as,
  Stdlib::Compat::Ipv4 $remote_ip,

  Optional[Stdlib::Compat::Ipv4] $update_source = undef,
  Optional[Integer[1]] $remote_as = undef,
  Optional[Integer[1, 65535]] $remote_port = undef,
) {

  concat::fragment { "bgp_${name}":
    target  => $config_path,
    content => epp('bird/protocols/bgp.epp', {
      name          => $name,
      local_as      => $local_as,
      update_source => $update_source,
      remote_as     => $remote_as,
      remote_ip     => $remote_ip,
      remote_port   => $remote_port,
    }),
    order   => 50,
  }
}
