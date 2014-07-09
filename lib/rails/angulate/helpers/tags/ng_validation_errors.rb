module Rails
  module Angulate
    module Helpers
      module Tags
        class NgValidationErrors < ActionView::Helpers::Tags::Base
          include TagCommon

          def render
            # We can't use content_tag with a block (no self.output_buffer)
            # so we pass in content
            container(angular_error_list_html) unless validators.empty?
          end

          private

          def options
            @_options ||= @options.symbolize_keys
          end

          def container(content)
            content_tag :ul, content, container_attrs
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

            attrs = {
              'ng-show' => ng_show
            }

            attrs[:class] = configuration.default_error_classes
              .dup.concat([options[:class]]).compact.uniq.join(' ')

            attrs
          end

          def validate_on_options
            validate_on = (options[:validate_on] || configuration.validate_on)
            case validate_on
            when Array
              validate_on = validate_on.each_with_index.map { |cond, i| [cond, i == validate_on.length - 1 ? nil : :and] }
            when Symbol
              options[:validate_on] = Array.wrap(validate_on)
              validate_on = validate_on_options
            end
            validate_on
          end

          def validate_on
            field = angular_form_field_object_name
            form = angular_form_object_name

            return validate_on_options if validate_on_options.is_a?(String)

            validate_on_options.inject('') do |str, (kind, op)|
              op = case op
              when :and
                ' && '
              when :or
                ' || '
              else
                ''
              end

              str << (kind == :submit_attempt ? "#{form}.$#{kind}" : "#{field}.$#{kind}") << op
            end
          end
        end
      end
    end
  end
end
