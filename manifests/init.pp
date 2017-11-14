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
# @param confd_path Specifies the directiry for partial configuration falies
# @param router_id The global router id
#
class bird (
  String[1] $package_ensure,
  Enum['running', 'stopped'] $service_ensure,
  Stdlib::Absolutepath $conf_path,
  Stdlib::Absolutepath $confd_path,
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
        File[$conf_path],
      ],
    }
  })

  file { $confd_path:
    ensure  => directory,
    require => Package['bird'],
  }

  file { $conf_path:
    ensure  => present,
    content => epp('bird/bird.conf.epp', {
      confd_path => $confd_path,
      router_id  => $router_id,
    }),
    require => Package['bird'],
  }
}
