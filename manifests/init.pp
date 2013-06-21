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
# arcsize: limit the ARC to an absolute value, in MB.
# arcpercent: if arcsize is empty, limit to a percentage. Defaults to 25.
#
# === Examples
#
#  class { zfs: 
#    arcpercent => 25,
#  }
#
# === Authors
#
# Arnaud Gomes-do-Vale <Arnaud.Gomes@ircam.fr>
#
# === Copyright
#
# Copyright 2013 Michigan State University Board of Trustees
# Copyright 2013 Arnaud Gomes-do-Vale
#
class zfs ( $arcpercent = '25', $arcsize_mb = '0' ) {

  include dkms
  # comment out the following include to not manage the size of the ARC.
  include zfs::arclimit

    case $::operatingsystem {
      'RedHat', 'CentOS', 'Scientific': {

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
          require   => File['/etc/modprobe.d/zfs.conf']
        }
      }

    'Ubuntu': {
      include apt
      include dkms
      apt::ppa { 'ppa:zfs-native/stable': }
      package { ['python-software-properties', 'bison', 'flex', 'libelf-dev', 'zlib1g-dev', 'libc6-dev', 'libdwarf-dev', 'binutils-dev']:
        ensure  => installed,
      } ~>
      package { 'ubuntu-zfs':
        ensure => present,
        notify => Class['dkms'],
        require => Apt::Ppa ['ppa:zfs-native/stable'],
      }
      # We explicitly run dkms to build the ZFS modules for the currently-running
      # kernel. Otherwise ZFS won't work until an apt-get upgrade.
      exec { 'zfs_dkms':
        require => Class['dkms'],
        command => '/etc/kernel/postinst.d/dkms',
        creates => "/lib/modules/${kernelrelease}/updates/dkms/zfs.ko"
      }
    }
  }
}
