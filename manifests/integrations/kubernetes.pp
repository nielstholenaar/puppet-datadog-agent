# Class: datadog_agent::integrations::kubernetes
#
# This class will install the necessary configuration for the kubernetes integration
#
# See the sample kubernetes.d/conf.yaml for all available configuration options
# https://github.com/DataDog/integrations-core/blob/master/kubernetes/datadog_checks/kubernetes/data/conf.yaml.example
#
# Parameters:
#   $url:
#     The URL for kubernetes API
#
#   $tags:
#     optional array of tags
#
#
#
# Sample Usage:
#
#   class { 'datadog_agent::integrations::kubernetes' :
#     api_server_url       => 'https://kubernetes:443',
#     apiserver_client_crt => '/etc/ssl/certs/crt',
#     apiserver_client_key => '/etc/ssl/private/key',
#     kubelet_client_crt   => '/etc/ssl/certs/crt',
#     kubelet_client_key   => '/etc/ssl/private/key',
#   }
#
class datadog_agent::integrations::kubernetes (
  String $api_server_url       = 'Enter_Your_API_url',
  String $apiserver_client_crt = '/path/to/crt',
  String $apiserver_client_key = '/path/to/key',
  String $kubelet_client_crt   = '/path/to/crt',
  String $kubelet_client_key   = '/path/to/key',
  Array $tags                  = [],

) inherits datadog_agent::params {
  require datadog_agent

  $dst_dir = "${datadog_agent::params::conf_dir}/kubernetes.d"

  file { $dst_dir:
    ensure  => directory,
    owner   => $datadog_agent::dd_user,
    group   => $datadog_agent::params::dd_group,
    mode    => $datadog_agent::params::permissions_directory,
    require => Package[$datadog_agent::params::package_name],
    notify  => Service[$datadog_agent::params::service_name],
  }
  $dst = "${dst_dir}/conf.yaml"

  file { $dst:
    ensure  => file,
    owner   => $datadog_agent::dd_user,
    group   => $datadog_agent::params::dd_group,
    mode    => $datadog_agent::params::permissions_file,
    require => Package[$datadog_agent::params::package_name],
    notify  => Service[$datadog_agent::params::service_name],
    content => template('datadog_agent/agent-conf.d/kubernetes.yaml.erb'),
  }
}
