# == Class: zfs
#
# This module installs ZFS from http://zfsonlinux.org/ on Linux hosts. It
# does not manage pools, just the kernel-level support.
#
# === Parameters
#
# None.
#
# === Variables
#
# None.
#
# === Examples
#
#  class { zfs: }
#
# === Authors
#
# Arnaud Gomes-do-Vale <Arnaud.Gomes@ircam.fr>
#
# === Copyright
#
# Copyright 2013 Arnaud Gomes-do-Vale
#
class zfs {

  include dkms

  if $::operatingsystem in ['RedHat', 'CentOS', 'Scientific'] {

    package { 'zfs-release':
      ensure   => present,
      provider => rpm,
      source   => 'http://archive.zfsonlinux.org/epel/zfs-release-1-2.el6.noarch.rpm',
    } ->
    package { 'zfs':
      ensure => present,
      notify => Class['dkms'],
    } ~>
    service { 'zfs':
      ensure    => running,
      enable    => true,
      subscribe => Class['dkms'],
    }

  }

}
