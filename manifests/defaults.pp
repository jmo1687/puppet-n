 class n::defaults {
  Exec {
    path => ['/bin/', '/usr/bin/', '/usr/local/bin'],
  }

  Package {
    ensure => present,
  }
}
