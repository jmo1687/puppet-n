class n::helpers {
  define installDepencies {
    if ! defined(Package[$name]) {
      package { $name: }
    }
  }
}
