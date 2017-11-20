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
class bird (
  String[1] $package_ensure,
  Enum['running', 'stopped'] $service_ensure,
  Stdlib::Absolutepath $conf_path,
) {

  package { 'bird':
    ensure => $package_ensure,
  }

  service { 'bird':
    ensure     => $service_ensure,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => [
      Package['bird'],
      Concat[$conf_path],
    ],
  }

  concat { $conf_path:
    ensure  => present,
    require => [
      Package['bird'],
    ],
  }

  contain bird::global
}
