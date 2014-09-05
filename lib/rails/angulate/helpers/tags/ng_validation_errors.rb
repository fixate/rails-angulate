module Rails
  module Angulate
    module Helpers
      module Tags
        class NgValidationErrors < ActionView::Helpers::Tags::Base
          include TagCommon

          def render
            # We can't use content_tag with a block (no self.output_buffer)
            # so we pass in content
            container(error_list_html) unless validators.empty? && !has_optional_validators?
          end

          private

          def options
            @_options ||= @options.symbolize_keys
          end

          def container(content)
            content_tag :ul, content, container_attrs
          end

          def error_list_html
            html = ''

            html << validators.map do |validator|
              mapper = validator_mapper_for(validator)
              mapper.error_messages.map do |error_type, msg|
                content_tag :li, msg, 'ng-show' => "#{form_field_object_name}.$error.#{error_type}"
              end.join
            end.join

            html << (extra_validators || '')
            html.html_safe
          end

          def extra_validators
            options.inject('') do |html, (k, v)|
              k = k.to_s
              html << if k.start_with?('$')
                content_tag(:li, v, 'ng-show' => "#{form_field_object_name}.$error.#{k[1..-1]}")
              else
                ''
              end
            end
          end

          def has_optional_validators?
            options.keys.any? { |k| k.to_s.start_with?('$') }
          end

          def container_attrs
            ng_show = configuration.validate_show_condition % {
              model: @object_name,
              form: form_object_name,
              field: form_field_object_name,
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
            form = form_object_name

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

              str << (kind == :submit_attempt ? "#{form}.$#{kind}" : "#{form}['#{field_name}'].$#{kind}") << op
            end
          end
        end
      end
    end
  end
end
