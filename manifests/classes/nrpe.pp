class nagios::nrpe {

  package { nagios-nrpe-server: }

  service { nagios-nrpe-server: 
    ensure => running,
    require => Package[nagios-nrpe-server],
    pattern => "/usr/sbin/nrpe"
  }

  file { "/etc/nagios/nrpe_local.cfg":
    content => template("nagios/nrpe_local.cfg"),
    require => Package[nagios-nrpe-server],
    notify => Service[nagios-nrpe-server]
  }

  file { "/etc/nagios/nrpe.d/":
    ensure => directory,
    require => Package[nagios-nrpe-server]
  }

  file { "/etc/nagios/nrpe.d/defaults.cfg":
    source => "puppet:///nagios/nrpe_defaults.cfg",
    notify => Service[nagios-nrpe-server]
  }

  package { nagios-plugins: }

}