class nagios::nsca::server {

  package { nsca: }

  service { nsca:
    ensure => running,
    require => [ Package[nsca], File["/var/run/nagios"] ]
  }

  file { "/var/run/nagios":
    ensure => directory
  }

  file {
    "/var/lib/nagios3/rw":
    owner => nagios,
    group => www-data,
    mode => 2710;

    "/var/lib/nagios3":
    owner => nagios,
    group => nagios,
    mode => 751
  }

  file { "/etc/nagios3/services/munin-plugins.cfg":
    source => "puppet:///modules/nagios/services/munin-plugins.cfg";

    "/etc/nagios3/services/passive-service.cfg":
    source => "puppet:///modules/nagios/services/passive-service.cfg"
  }

  file { '/etc/munin/munin-conf.d/nagios.conf':
    source => 'puppet:///modules/nagios/munin.conf.contactnagios',
    require => Package['munin']
  }
  file { '/usr/local/bin/munin-nagios-command':
    source => 'puppet:///modules/nagios/munin-nagios-command',
    mode => 755
  }

  file { "/etc/nsca.cfg":
    source => "puppet:///modules/nagios/nsca.cfg",
    notify => Service[nsca]
  }

  file { "/usr/bin/munin-cron":
    source => "puppet:///modules/nagios/munin-cron",
    mode => 755
  }

  include nagios::nsca::tiger
}

class nagios::nsca::tiger {
  if $tiger_enabled {
    tiger::ignore { nagios_nsca: }
  }
}
