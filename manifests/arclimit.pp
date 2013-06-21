class zfs::arclimit {

  # We require the memorysize_mb fact from Facter 1.7, as it's much more parseable.
  if $memorysize_mb {
    $arcsize_mb = $zfs::arcsize_mb
    $arcpercent = $zfs::arcpercent * 0.01
    if $arcsize_mb == 0 {
      # TODO: somebody that knows ruby better than I should clean this up.
      $exact_arcsize = $memorysize_mb * $arcpercent * 1024 * 1024
      $arcsize = inline_template("<%= exact_arcsize.round %>" )
    }
    else {
      $arcsize = $arcsize_mb * 1024 * 1024
    }
  }
  else {
    # if you are running ZFS on a system with less than 512MB of ram, 
    # you are insane. This should be a safe fallback.
    notify { 'Facter 1.7 or greater is needed. ARC set to hardcoded value (512M)': }
    $arcsize = 536870912
  }


  file { '/etc/modprobe.d/zfs.conf':
    content => "options zfs zfs_arc_max=$arcsize",
    mode    => 644,
    owner   => 'root',
    group   => 'root',
  }
}
