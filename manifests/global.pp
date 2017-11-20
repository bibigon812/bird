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
class bird::global (
  Stdlib::Compat::Ipv4 $router_id,
  Optional[String[1]] $router_id_from,
) {

  concat::fragment { 'bird_conf_10_global':
    target  => $bird::conf_path,
    content => epp('bird/bird.conf.epp', {
      router_id      => $router_id,
      router_id_from => $router_id_from,
    }),
    order   => 10,
  }

  contain bird::templates
  contain bird::protocols
}
