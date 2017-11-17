# bird
#
# This class manages the service BIRD
#
# @summary Manages the service BIRD
#
# @example
#   include bird
#
# @param
#   package_ensure
#     The package ensure value
#
# @param
#   service_enusre
#     The service ensure value
#
# @param
#   conf_path
#     Specifies the configureation file. Default: '/etc/bird.conf'
#
# @param
#   router_id
#     Set BIRD's router ID. It's a world-wide unique identification of your
#     router, usually one of router's IPv4 addresses. Default: in IPv4 version,
#     the lowest IP address of a non-loopback interface. In IPv6 version, this
#     option is mandatory.
#
class bird (
  String[1] $package_ensure,
  Enum['running', 'stopped'] $service_ensure,
  Stdlib::Absolutepath $conf_path,
  Stdlib::Compat::Ipv4 $router_id,
) {

  ensure_packages({
    'bird' => {
      ensure => $package_ensure,
    }
  })

  ensure_resources('service', {
    'bird' => {
      ensure     => $service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => [
        Package['bird'],
        Concat[$conf_path],
      ],
    }
  })

  concat { $conf_path:
    ensure  => present,
    require => [
      Package['bird'],
    ],
  }

  concat::fragment { 'bird_conf_10_global':
    target  => $conf_path,
    content => epp('bird/bird.conf.epp', {
      router_id  => $router_id,
    }),
    order   => 10,
  }

  contain bird::templates
  contain bird::protocols
}
