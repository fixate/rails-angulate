angular.module 'angulate.directives'

  # Generic validator
  .directive 'angValidator', ->
    restrict: 'AC',
    require: 'ngModel'
    scope:
      validIf: '&angValidIf'
    link: (scope, element, attrs, ctrl) ->
      type = attrs.angValidator || 'validator'

      validator = (value) ->
        return unless value?
        valid = scope.validIf(value: value)
        ctrl.$setValidity(type, valid)
        return value if valid

      ctrl.$parsers.push(validator)
      ctrl.$formatters.push(validator)

