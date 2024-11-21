# Class: datadog_agent::integrations::jenkins
#
# This class will install the necessary configuration for the jenkins integration
#
# Parameters:
#   $path:
#       Jenkins path. Defaults to '/var/lib/jenkins'
#
# Sample Usage:
#
#  class { 'datadog_agent::integrations::jenkins' :
#    path     => '/var/lib/jenkins',
#  }
#
#
class datadog_agent::integrations::jenkins (
  $path = '/var/lib/jenkins'
) inherits datadog_agent::params {
  require datadog_agent

  $dst_dir = "${datadog_agent::params::conf_dir}/jenkins.d"

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
    content => template('datadog_agent/agent-conf.d/jenkins.yaml.erb'),
    require => Package[$datadog_agent::params::package_name],
    notify  => Service[$datadog_agent::params::service_name],
  }
}
