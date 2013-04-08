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

  if $::operatingsystem in ['RedHat', 'CentOS', 'Scientific'] {

    # We need kernel-headers for DKMS.
    if !defined(Package['kernel-headers']) {
      package { 'kernel-headers':
        ensure => $::kernelrelease,
        before => Package['zfs'],
      }
    }

    package { 'zfs-release':
      ensure   => present,
      provider => rpm,
      source   => 'http://archive.zfsonlinux.org/epel/zfs-release-1-2.el6.noarch.rpm',
    } ->
    package { 'zfs':
      ensure => present,
    } ~>
    service { 'zfs':
      ensure => running,
      enable => true,
    }

  }

}
