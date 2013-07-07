# Puppet-n

Installs [n](https://github.com/visionmedia/n), nodejs and npm provider for Ubuntu.

## Installation

```
git submodule add https://github.com/hstkk/puppet-n.git modules/n
```

## Usage

- Install n

```
include n
```

- Install n, stable and unstable nodejs

```
class { 'n':
  versions => ['stable', 'latest'],
}
```

### NPM provider

1. Select nodejs version
2. Install npm packages

```
exec { "use-node-stable":
  command => 'n stable',
  require => Class['n'],
}

package { 'express':
  provider => npm,
  require  => Exec['use-node-stable'],
}
```
