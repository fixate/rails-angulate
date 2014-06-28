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
  restrict: 'E'
  priority: 10
  require: 'form'
  compile: ->
    pre: (scope, element, attrs, form) ->
      element.attr('novalidate', 'novalidate')
      form.$submitted = false
      _submit = (e) ->
        e.preventDefault()
        if form.$invalid
          e.stopPropagation()
          e.returnValue = false # IE
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
  .directive('textarea', blurifyDirective)
  .directive('select', blurifyDirective)
  .directive('blurify', blurifyDirective)

  .directive('form', formExtensions)
  .config ['$provide', ($provide) ->
    $provide.decorator 'ngSubmitDirective', ['$delegate', ($delegate) ->
      # Remove default ngSubmit
      $delegate.shift()
      $delegate
    ]
  ]
  # Override with our own directive which checks for stopped propagation
  # TODO: File issue with angular (?)
  .directive 'ngSubmit', ['$parse', ($parse) ->
    compile: ($element, attr) ->
      fn = $parse(attr['ngSubmit'])
      return (scope, element) ->
        element.on 'submit', (event) ->
          unless event.isPropagationStopped?()
            scope.$apply ->
              fn(scope, $event: event)
          return
        return
  ]
