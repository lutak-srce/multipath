# Class: multipath
#
# This module manages multipath
#
# Parameters:
#
# Actions:
#
# Requires: Multipath often requirest the iscsi module
#
# Sample Usage: include multipath
#
# [Remember: No empty lines between comments and class definition]
class multipath (
  $template = 'puppet:///modules/multipath/multipath.conf',
) {
  $mod = 'multipath'
  package { 'device-mapper-multipath': }
  file { '/etc/multipath.conf':
    require => Package['device-mapper-multipath'],
    source  => $template,
  }
  service { 'multipathd':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/multipath.conf'],
    notify    => Exec['multipath'],
  }

  exec { 'multipath':
    path        => '/bin:/usr/bin:/usr/sbin:/sbin',
    command     => 'multipath',
    logoutput   => true,
    refreshonly => true,
  }

}
