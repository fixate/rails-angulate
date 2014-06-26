module Rails
  module Angulate
    module Helpers
      module Tags
        class NgValidationErrors < ActionView::Helpers::Tags::Base
          include TagCommon

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
              mapper = validator_mapper_for(validator)
              mapper.error_messages.map do |error_type, msg|
                content_tag :li, msg, 'ng-show' => "#{angular_form_field_object_name}.$error.#{error_type}"
              end.join
            end.join.html_safe
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

          def validate_on
            field = angular_form_field_object_name

            configuration.validate_on.map do |kind|
              "#{field}.$#{kind}"
            end.join(' && ')
          end
        end
      end
    end
  end
end
