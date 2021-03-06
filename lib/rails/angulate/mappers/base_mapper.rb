module Rails
  module Angulate
    module Mappers
      class BaseMapper
        attr_reader :validator, :model, :attribute

        def self.inherited(mapper)
          Mappers.register_mapper(mapper)
        end

        delegate :configuration, to: Rails::Angulate

        def initialize(model, attribute, validator)
          @model = model
          @attribute = attribute
          @validator = validator
        end

        def error_messages
          []
        end

        def full_message(message)
          return message if attribute == :base
          attr_name = attribute.to_s.tr('.', '_').humanize
          attr_name = @model.class.human_attribute_name(attribute, default: attribute.to_s.humanize)
          with_i18n do |locale|
            locale.t(:format, {
              default:  "%{attribute} %{message}",
              attribute: attr_name.to_s.humanize,
              message:   message
            })
          end
        end

        def error_messages
          default_message = validator_options[:message]

          with_i18n do |locale|
            {
              kind_to_ng(validator.kind) => default_message || locale.t(:"messages.#{validator.kind}", {
                model: model.class.name.humanize,
                  attribute: attribute.to_s.humanize
              })
            }
          end
        end

        protected

        def translate_params
          {
            model: model.class.name.humanize,
            attribute: attribute.to_s.humanize,
          }
        end

        def kind_to_ng(kind)
          configuration.validator_mappings[kind] || kind
        end

        def mapped_kind
          kind = validator.kind
          configuration.validator_mappings[kind] || kind
        end

        def with_i18n(options = {}, &block)
          I18n.with_options scope: [:angulate, :errors], &block
        end

        def validator_options
          validator.options
        end
      end
    end
  end
end
