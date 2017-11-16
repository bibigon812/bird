# bird
#
# This class manages the service BIRD
#
# @summary Manages the service BIRD
#
# @example
#   include bird
#
# @param package_ensure The package ensure value
# @param service_enusre The service ensure value
# @param conf_path Specifies the configureation file
# @param router_id The global router id
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

  concat::fragment { 'bird-conf-10-global':
    target  => $conf_path,
    content => epp('bird/bird.conf.epp', {
      router_id  => $router_id,
    }),
    order   => 10,
  }
}
