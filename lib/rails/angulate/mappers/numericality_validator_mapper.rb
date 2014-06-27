module Rails
  module Angulate
    module Mappers
      class NumericalityValidatorMapper < Base
        CHECKS = ActiveModel::Validations::NumericalityValidator::CHECKS

        def ng_attributes
          opts = numericality_options

          condition = opts.map do |option, option_value|
            if allow_only_integer?
              "Math.round(value) == value"
            else
              case option
              when :odd
                "value % 2 != 0"
              when :even
                "value % 2 == 0"
              else
                case option_value
                when Proc
                  option_value = option_value.call(record)
                when Symbol
                  option_value = record.send(option_value)
                end

                op = CHECKS[option]

                "value #{op} #{option_value}"
              end
            end
          end.join(' && ')

          {}.tap do |attrs|
            attrs["ang-validator"] = "numericality"
            attrs["ang-valid-if"] = condition
          end
        end

        # def error_messages
        #   messages = {}
        #   default_message = validator_options[:message]

        #   with_i18n do |locale|
        #     validator.class::MESSAGES.each do |key, msg|
        #       if default_message.nil?
        #         next unless validator_options[key]

        #         count = validator_options[key]

        #         message = locale.t(
        #           :"messages.#{msg}",
        #           model: model.class.name.humanize,
        #           attribute: attribute.to_s.humanize,
        #           count: count
        #         )

        #         messages[OPTION_MAP[key]] = full_message(message)
        #       else
        #         messages[OPTION_MAP[key]] = default_message
        #       end
        #     end
        #   end

        #   messages
        # end

        protected

        def allow_only_integer?
          case validator_options[:only_integer]
          when Symbol
            model.send(validator_options[:only_integer])
          when Proc
            validator_options[:only_integer].call(model)
          else
            validator_options[:only_integer]
          end
        end

        private

        def numericality_options
          @numericality_options ||= validator_options.slice(*CHECKS.keys)
        end
      end
    end
  end
end

