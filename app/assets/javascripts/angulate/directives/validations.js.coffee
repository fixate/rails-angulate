# Add $blur flag to form controller
blurifyDirective = ['$timeout', ($timeout) ->
  restrict: 'E',
  require: '^form'
  link: (scope, element, attrs, form) ->
    return unless attrs.name
    form.$blur = false

    element.on 'blur', handler = ->
      field = form[attrs.name]
      if field?
        $timeout ->
          field.$blur = true

    scope.$on '$destroy', ->
      element.off 'blur', handler
]

angular.module 'angulate.directives'

  .directive('input', blurifyDirective)
  .directive('select', blurifyDirective)
  .directive('blurify', blurifyDirective)
