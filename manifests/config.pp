class check_mk_livestatus::config {
  if $check_mk_livestatus::enable_livestatus_neb_module {
    exec {'enable_livestatus_neb_module':
      command => "echo \"broker_module=/usr/lib/check_mk/livestatus.o ${check_mk_livestatus::xinetd_server_args} debug=${check_mk_livestatus::debug_on}\" >>${check_mk_livestatus::nagios3_config}",
      path    => '/bin/:/usr/bin',
      unless  => "grep -q 'livestatus.o' ${check_mk_livestatus::nagios3_config}; echo \$?",
      notify  => Service['nagios'],
    }
  }

  if $check_mk_livestatus::enable_broker_everything {
    augeas {'enable_broker_everything':
      context => "/files/${check_mk_livestatus::nagios3_config}",
      changes => [
        'set event_broker_options -1',
      ],
      notify  => Service['nagios'],
    }
  }


  file {$check_mk_livestatus::xinetd_config:
    ensure  => present,
    content => template('check_mk_livestatus/xinetd_livestatus.erb'),
    notify  => Service[$check_mk_livestatus::params::service_name],
  }
}

