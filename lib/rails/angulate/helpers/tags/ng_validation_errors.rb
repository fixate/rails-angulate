module Rails
  module Angulate
    module Helpers
      module Tags
        class NgValidationErrors < ActionView::Helpers::Tags::Base
          include Forwardable

          def render
            attrs = {}
            [:id, :class].each do |key|
              if options.include?(key)
                value = options[key]
                attrs[key] = value unless value.blank?
              end
            end

            # We can't use content_tag with a block (no self.output_buffer)
            # so we pass in content
            container attrs, angular_error_list_html
          end

          private

          def options
            @_options ||= @options.symbolize_keys
          end

          def container(attrs, content)
            content_tag :ul, content, attrs.merge(container_attrs)
          end

          def angular_error_list_html
            validators.map do |validator|
              content_tag :li, error_message_for(validator), 'ng-show' => "#{angular_form_field_object_name}.$error.#{map_validator_to_ng(validator.kind)}"
            end.join.html_safe
          end

          def error_message_for(validator)
            I18n.with_options locale: options[:locale], scope: [:angulate, :validation, :errors] do |locale|
              locale.t(validator.kind) % {model: @method_name}
            end
          end

          def map_validator_to_ng(kind)
            configuration.validator_mappings[kind] || kind
          end

          def container_attrs
            ng_show = configuration.validate_show_condition % {
              model: @object_name,
              form: angular_form_object_name,
              field: angular_form_field_object_name,
              validate_on: validate_on || 'true'
            }

            {
              'ng-show' => ng_show
            }
          end

          delegate :configuration, to: Rails::Angulate

          def validate_on
            field = angular_form_field_object_name

            configuration.validate_on.map do |kind|
              "#{field}.$#{kind}"
            end.join(' && ')
          end

          def angular_form_object_name
            @template_object.form_name_from_record_or_class(object)
          end

          def angular_form_field_object_name
            "#{angular_form_object_name}['#{@object_name}[#{@method_name}]']"
          end

          def validators
            object.class.validators
          end
        end
      end
    end
  end
end
