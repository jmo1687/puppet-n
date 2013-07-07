class n (
  $versions = [],
) inherits n::defaults {
  include n::helpers
  include n::params

  n::helpers::installDepencies { $n::params::depencies: }

  exec { 'install-n':
    command => "curl ${n::params::url} --output ${n::params::file}",
    creates => $n::params::file,
    require => Package[$n::params::depencies],
  }

  file { $n::params::file:
    mode    => 755,
    require => Exec['install-n'],
  } ->

  n::nodejs { $versions: }
}
