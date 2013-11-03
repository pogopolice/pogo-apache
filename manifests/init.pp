# == Class: apache
#
# Full description of class apache here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { apache:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class apache {
  case $::osfamily {
    'RedHat': {
      $httpd_user = 'apache'
      $httpd_group = 'apache'
      $httpd_pkg = 'httpd'
      $httpd_svc = 'httpd'
      $httpd_conf = '/etc/httpd/conf/httpd.conf'
    }
    'Debian': {
      $httpd_user = 'www-data'
      $httpd_group = 'www-data'
      $httpd_pkg = 'apache'
      $httpd_svc = 'apache'
      $httpd_conf = '/etc/httpd/conf/httpd.conf'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::osfamily}")
    }
  }
  File {
    owner => '$httpd_user',
    group => '$httpd_group',
    mode => '0644',
  }
  package { $httpd_pkg:
    ensure => present,
  }

  file { $httpd_conf:
    ensure => file,
    owner => 'root',
    group => 'root',
    require => Package[$httpd_pkg],
  }
  file { '/var/www':
    ensure => directory,
  }
  file { '/var/www/html':
    ensure => directory,
  }
  file { '/var/www/html/index.html':
    ensure => file,
    source => 'puppet:///modules/apache/index.html',
  }
  service { $httpd_svc:
    ensure => running,
    subscribe => File[$httpd_conf],
  }
}
