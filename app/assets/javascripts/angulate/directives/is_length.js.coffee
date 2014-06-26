angular.module 'angulate.directives'

  .directive 'ngIslength', ->
    restrict: 'AC',
    require: 'ngModel'
    link: (scope, element, attrs, ctrl) ->
      length = +attrs.ngIslength

      isLengthValidator = (value) ->
        validity = ctrl.$isEmpty(value) || value.length == length
        ctrl.$setValidity('islength', validity)
        return value if validity

      ctrl.$parsers.push(isLengthValidator)
      ctrl.$formatters.push(isLengthValidator)

