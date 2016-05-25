# == Class dns
#
# Currently does nothing
#
class dns(
  $forwarders             = '',
  $dnssec                 = false,
  $version                = '',
  $auth_nxdomain          = false,
  $include_local          = false,
  $include_default_zones  = true,
){

  package { 'bind':
    ensure => latest,
    name   => $bind_package,
  }

  file { "${confdir}/zones":
    ensure  => directory,
    mode    => '2755',
  }

}
