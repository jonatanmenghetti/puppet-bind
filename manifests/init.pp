# == Class dns
#
# Currently does nothing
#
class bind (
  $forwarders             = '',
  $version                = '',
  $auth_nxdomain          = false,
  $include_local          = false,
  $include_default_zones  = true,
) inherits bind::defaults {

  package { 'bind':
    ensure => latest,
    name   => $bind_package,
  }

  file {"${confdir}":
    ensure  => directory,
    owner    => $bind_user,
    mode    => 0644,
  }

  file { "${confdir}/zones":
    ensure  => directory,
    mode    => '2755',
    require => File["${confdir}"],
  }

  file { $namedconf:
    content => template('bind/named.conf.erb'),
  }

  concat { [
    "${confdir}/acls.conf",
    "${confdir}/keys.conf",
    "${confdir}/views.conf",
    ]:
    owner   => 'root',
    group   => $bind_group,
    mode    => '0644',
    require => Package['bind'],
    notify  => Service['bind'],
  }

  concat::fragment { 'named-acls-header':
    order   => '00',
    target  => "${confdir}/acls.conf",
    content => "# This file is managed by puppet - do not change! All changes will be lost\n",
  }

  concat::fragment { 'named-keys-header':
    order   => '00',
    target  => "${confdir}/keys.conf",
    content => "# This file is managed by puppet - do not change! All changes will be lost\n",
  }

  concat::fragment { 'named-views-header':
    order   => '00',
    target  => "${confdir}/views.conf",
    content => "# This file is managed by puppet - do not change! All changes will be lost\n",
  }

  service { 'bind':
    ensure     => running,
    name       => $bind_service,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }



}
