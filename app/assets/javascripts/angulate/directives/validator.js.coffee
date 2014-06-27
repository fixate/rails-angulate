angular.module 'angulate.directives'

  # Generic validator
  .directive 'angValidator', ->
    restrict: 'AC',
    require: '?ngModel'
    scope:
      validIf: '&angValidIf'
    link: (scope, element, attrs, ctrl) ->
      return unless ctrl?

      type = attrs.angValidator || 'validator'

      validate_each = (value, validations) ->
        result = true
        for type, v of validations
          valid = scope.$eval(v, value: value)
          ctrl.$setValidity(type, valid)
          result &&= valid

        result

      validator = (value) ->
        return unless value?
        valid = scope.validIf(value: value)
        valid = validate_each(value, valid) if typeof valid is 'object'

        ctrl.$setValidity(type, valid)
        return value if valid

      ctrl.$parsers.push(validator)
      ctrl.$formatters.push(validator)

