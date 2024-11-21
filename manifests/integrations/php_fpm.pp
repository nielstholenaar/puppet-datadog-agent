# Class: datadog_agent::integrations::php_fpm
#
# This class will set-up PHP FPM monitoring
#
# Parameters:
#   $status_url
#        URL to fetch FPM metrics. Default: http://localhost/status
#
#   $ping_url
#        URL to get a reliable check of the FPM pool. Default: http://localhost/ping
#
#   $ping_reply
#        Expected response from ping_url. Default: pong
#
#   $tags
#        Optional array of tags
#
#   $use_fastcgi
#        Use fastcgi to get stats.  Default: false
#
# Sample Usage:
#
#  class { 'datadog_agent::integrations::php_fpm' :
#    status_url     => 'http://localhost/fpm_status',
#    ping_url       => 'http://localhost/fpm_ping'
#  }
#

class datadog_agent::integrations::php_fpm (
  $status_url       = 'http://localhost/status',
  $ping_url         = 'http://localhost/ping',
  $ping_reply       = 'pong',
  $http_host        = undef,
  $tags             = [],
  $instances        = undef,
  $use_fastcgi      = 'false'
) inherits datadog_agent::params {
  require datadog_agent

  if !$instances {
    $_instances = [{
        'http_host' => $http_host,
        'status_url' => $status_url,
        'ping_url' => $ping_url,
        'ping_reply' => $ping_reply,
        'tags' => $tags,
        'use_fastcgi' => $use_fastcgi,
    }]
  } else {
    $_instances = $instances
  }

  $dst_dir = "${datadog_agent::params::conf_dir}/php_fpm.d"

  file { $dst_dir:
    ensure  => directory,
    owner   => $datadog_agent::dd_user,
    group   => $datadog_agent::params::dd_group,
    mode    => $datadog_agent::params::permissions_directory,
    require => Package[$datadog_agent::params::package_name],
    notify  => Service[$datadog_agent::params::service_name],
  }

  file { "${dst_dir}/conf.yaml":
    ensure  => file,
    owner   => $datadog_agent::dd_user,
    group   => $datadog_agent::params::dd_group,
    mode    => $datadog_agent::params::permissions_protected_file,
    content => template('datadog_agent/agent-conf.d/php_fpm.yaml.erb'),
    require => Package[$datadog_agent::params::package_name],
    notify  => Service[$datadog_agent::params::service_name],
  }
}
