# Class: datadog_agent::integrations::kubernetes
#
# This class will install the necessary configuration for the kubernetes integration
#
# Parameters:
#   $url:
#     The URL for kubernetes metrics
#
#   $tags:
#     optional array of tags
#
#
#
# Sample Usage:
#
#   class { 'datadog_agent::integrations::kubernetes_state' :
#     url  => 'http://kubernetes.com:8080/metrics',
#   }
#
class datadog_agent::integrations::kubernetes_state (
  $url = 'Enter_State_URL',
  $tags = [],

) inherits datadog_agent::params {
  require datadog_agent

  $dst_dir = "${datadog_agent::params::conf_dir}/kubernetes_state.d"

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
    mode    => $datadog_agent::params::permissions_file,
    require => Package[$datadog_agent::params::package_name],
    notify  => Service[$datadog_agent::params::service_name],
    content => template('datadog_agent/agent-conf.d/kubernetes_state.yaml.erb'),
  }
}
