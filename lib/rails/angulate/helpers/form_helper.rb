require 'rails/angulate/helpers/tags'

module Rails
  module Angulate
    module Helpers
      module FormHelper
        extend ActiveSupport::Concern

        def ng_form_for(record, options = {}, &block)
          options[:html] ||= {}
          options[:html]['ang-form'] = ""
          options[:html][:name] ||= options[:as] || ng_form_name(record)
          form_for(record, options, &block)
        end

        def ng_text_area(object_name, method, options = {})
          Tags::NgTextArea.new(object_name, method, self, options).render
        end

        def ng_text_field(object_name, method, options = {})
          Tags::NgTextField.new(object_name, method, self, options).render
        end

        def ng_email_field(object_name, method, options = {})
          Tags::NgEmailField.new(object_name, method, self, options).render
        end

        def ng_error_messages_for(object_name, method, options = {})
          Tags::NgValidationErrors.new(object_name, method, self, options).render
        end

        def ng_valid(record, &block)
          valid_wrapper(record, '$valid', &block)
        end

        def ng_invalid(record, &block)
          valid_wrapper(record, '$invalid', &block)
        end

        def ng_valid_for(record, attribute, &block)
          valid_wrapper(record, '$valid', attribute, &block)
        end

        def ng_invalid_for(record, attribute, &block)
          valid_wrapper(record, '$invalid', attribute, &block)
        end

        def ng_form_field_name(record, attribute)
          "#{ng_form_name(record)}['#{object_name_for(record)}[#{attribute}]']"
        end

        def ng_form_name(record)
          "#{object_name_for(record)}_form"
        end

        private

        def object_name_for(record)
          case record
          when String, Symbol
            record
          else
            object = record.is_a?(Array) ? record.last : record
            raise ArgumentError, "First argument in form cannot contain nil or be empty" unless object
            model_name_from_record_or_class(object).param_key
          end
        end

        def valid_wrapper(record, type, attribute = nil, &block)
          ng_if = attribute.nil? ? ng_form_name(record) : ng_form_field_name(record, attribute)
          content = capture(&block)
          content_tag :span, content.html_safe, 'ng-if' => "#{ng_if}.#{type}"
        end

      end
    end
  end
end
