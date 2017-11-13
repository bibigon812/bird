# bird
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include bird
#
# @param package_ensure The package ensure value
#
# @param service_enusre The service ensure value
#
class bird (
  String[1] $package_ensure,
  Enum['running', 'stopped'] $service_ensure,
  Stdlib::Absolutepath $config_path,
) {

  ensure_packages({
    'bird' => {
      ensure => $package_ensure,
    }
  })

  ensure_resources('service', {
    'bird' => {
      ensure    => $service_ensure,
      subscribe => Package['bird'],
    }
  })

  concat { $config_path:
    ensure => present,
  }
}
