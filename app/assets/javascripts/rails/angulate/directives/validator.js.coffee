angular.module 'angulate.directives'

  # Generic validator
  .directive 'angValidator', ->
    restrict: 'AC',
    require: '?ngModel'
    scope:
      validIf: '&angValidIf'
    link: (scope, element, attrs, ctrl) ->
      return unless ctrl?

      validationType = attrs.angValidator || 'validator'

      validate_each = (value, validationExpr) ->
        boolOrValidations = scope.$eval(validationExpr, value: value)
        return boolOrValidations if typeof valid is 'boolean'

        result = true
        for type, condition of boolOrValidations
          valid = scope.$eval(condition, value: value)
          ctrl.$setValidity(type, valid)
          result &&= valid

        result

      validator = (value) ->
        return unless value?

        if attrs.angValidIf
          valid = validate_each(value, attrs.angValidIf)

          ctrl.$setValidity(validationType, valid)
          return value if valid

      ctrl.$parsers.push(validator)
      ctrl.$formatters.push(validator)

