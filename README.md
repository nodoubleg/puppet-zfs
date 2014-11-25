zfs
===

This puppet module installs ZFS on Linux on either Ubuntu or a RHEL derivative (CentOS, Scientific Linux, etc).
EL 7 support is incomplete at this time.

The puppetlabs/apt module is not listed as a dependency, as RHEL shops certainly won't need it. It is required for Ubuntu.

Facter 1.7 or higher is needed to for automatic configuration of the ARC size. This module will constrain ZFS to 25% of the system's ram by default, suitable for small VMs.

The system should probably have 1GB or more of ram.

Version 2 removes the dependency for the dkms puppet module.

License
-------

This module is distributed under the terms of the GNU General Public License,
version 3. See COPYING for details.

Contact
-------

Greg Mason <gmason@msu.edu>

original author: Arnaud Gomes-do-Vale <Arnaud.Gomes@ircam.fr>

Support
-------

Please log issues at our [Projects site](https://gitlab.msu.edu/gmason/puppet-zfs/issues)
