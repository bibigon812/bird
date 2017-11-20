# bird::global
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include bird::global
#
# @param
#   router_id
#     Set BIRD's router ID. It's a world-wide unique identification of your
#     router, usually one of router's IPv4 addresses. Default: in IPv4 version,
#     the lowest IP address of a non-loopback interface. In IPv6 version, this
#     option is mandatory.
#
# @param
#   router_id_from
#     Set BIRD's router ID based on an IP address of an interface specified by
#     an interface pattern. The option is applicable for IPv4 version only. See
#     interface section for detailed description of interface patterns with
#     extended clauses.
#
# @param
#   listen_bgp
#     This option allows to specify address and port where BGP protocol should
#     listen. It is global option as listening socket is common to all BGP
#     instances. Default is to listen on all addresses (0.0.0.0) and port 179.
#     In IPv6 mode, option dual can be used to specify that BGP socket should
#     accept both IPv4 and IPv6 connections (but even in that case, BIRD would
#     accept IPv6 routes only). Such behavior was default in older versions of
#     BIRD.
#
# @param
#   tables
#     Create a new routing table. The default routing table is created
#     implicitly, other routing tables have to be added by this command. Option
#     sorted can be used to enable sorting of routes, see sorted table
#     description for details.
#
class bird::global (
  Struct[{
    Optional[address] => Stdlib::Compat::Ipv4,
    Optional[port]    => Integer[1,65535],
    Optional[dual]    => Boolean,
  }] $listen_bgp,
  Stdlib::Compat::Ipv4 $router_id,
  Optional[String[1]] $router_id_from,
  Array[Pattern[/\A\w+(?:\ssorted)?\Z/]] $tables,
) {

  $listen_bgp_ = $listen_bgp.reduce('') |String $memo, $value| {
    case $value[0] {
      'address': { $string = "address ${value[1]}" }
      'port':    { $string = "port ${value[1]}" }
      'dual':    {
        if $value[1] {
          $string = 'dual'
        }
      }
      default:   { $string = '' }
    }
    strip("${memo} ${string}")
  }

  concat::fragment { 'bird_conf_10_global':
    target  => $bird::conf_path,
    content => epp('bird/bird.conf.epp', {
      listen_bgp     => $listen_bgp_,
      router_id      => $router_id,
      router_id_from => $router_id_from,
      tables         => $tables,
    }),
    order   => 10,
  }
}
