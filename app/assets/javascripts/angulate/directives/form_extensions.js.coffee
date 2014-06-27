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

formExtensions = ['$timeout', ($timeout) ->
  restrict: 'E',
  require: 'form',
  link: (scope, element, attrs, form) ->
    element.attr('novalidate', 'novalidate')
    form.$submitted = false
    _submit = (e) ->
      if form.$invalid
        e.preventDefault()
        $timeout ->
          form.$submit_attempt = true
      else
        $timeout ->
          form.$submitted = true

    element.on 'submit', _submit

    scope.$on '$destroy', ->
      element.off 'submit', _submit
]

angular.module 'angulate.directives'

  .directive('input', blurifyDirective)
  .directive('select', blurifyDirective)
  .directive('blurify', blurifyDirective)

  .directive('form', formExtensions)
