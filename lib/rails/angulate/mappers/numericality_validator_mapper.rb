module Rails
  module Angulate
    module Mappers
      class NumericalityValidatorMapper < BaseMapper
        CHECKS = ActiveModel::Validations::NumericalityValidator::CHECKS

        def ng_attributes
          {}.tap do |attrs|
            attrs["ang-validator"] = "numericality"
            attrs["ang-valid-if"] = numericality_conditions.to_json
          end
        end

        def error_messages
          messages = {}
          default_message = validator_options[:message]

          default_message || with_i18n do |locale|
            numericality_options.each do |option, option_value|
              messages[option] = full_message(
                locale.t :"messages.#{option}",
                translate_params.merge(count: option_value)
              )

              if allow_only_integer?
                messages[:only_integer] = full_message(
                  locale.t :"messages.not_an_integer",
                  translate_params.merge(count: option_value)
                )
              end
            end
          end

          messages
        end

        protected

        def numericality_conditions
          numericality_options.inject({}) do |hash, (option, option_value)|
            case option
            when :odd
              hash[option] = "value % 2 != 0"
            when :even
              hash[option] = "value % 2 == 0"
            when :only_integer
              hash[option] = %q{value / 1 == value}
            else
              case option_value
              when Proc
                option_value = option_value.call(record)
              when Symbol
                option_value = record.send(option_value)
              end

              op = CHECKS[option]

              hash[option] = "value #{op} #{option_value}"
            end

            hash
          end
        end

        def allow_only_integer?
          case validator_options[:only_integer]
          when Symbol
            model.send(validator_options[:only_integer])
          when Proc
            validator_options[:only_integer].call(model)
          else
            !!validator_options[:only_integer]
          end
        end

        def numericality_options
          @numericality_options ||= validator_options.slice(*CHECKS.keys + [:only_integer])
        end
      end
    end
  end
end

