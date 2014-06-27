module Rails
  module Angulate
    module Mappers
      class LengthValidatorMapper < Base
        OPTION_MAP = { is: :islength, minimum: :minlength, maximum: :maxlength }.freeze

        def ng_attributes
          opts = validator_options
          {}.tap do |attrs|
            validator_options.each do |key, value|
              attrs["ng-#{OPTION_MAP[key]}"] = opts[key] if opts[key].present?
            end
          end
        end

        def error_messages
          messages = {}
          default_message = validator_options[:message]

          with_i18n do |locale|
            validator.class::MESSAGES.each do |key, msg|
              if default_message.nil?
                next unless validator_options[key]

                count = validator_options[key]

                message = locale.t(
                  :"messages.#{msg}",
                  model: model.class.name.humanize,
                  attribute: attribute.to_s.humanize,
                  count: count
                )

                messages[OPTION_MAP[key]] = full_message(message)
              else
                messages[OPTION_MAP[key]] = default_message
              end
            end
          end

          messages
        end
      end
    end
  end
end

