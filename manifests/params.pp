class n::params {
  $url  = 'https://raw.github.com/visionmedia/n/master/bin/n'
  $file = '/usr/local/bin/n'

  case $::operatingsystem {
    'ubuntu': {
      $depencies = ['curl']
    }
    default: {
      fail('Unsupported OS')
    }
  }
}
