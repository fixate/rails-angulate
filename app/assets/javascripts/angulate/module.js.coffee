throw "In order to use Angulate you must include AngularJS yourself." unless angular?

angular.module 'angulate', [
  'angulate.directives'
]
