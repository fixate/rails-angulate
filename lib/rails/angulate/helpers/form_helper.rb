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

        def ng_select(object_name, method, choices = {}, options = {}, html_options = {})
          Tags::NgSelect.new(object_name, method, self, choices, options, html_options).render
        end

        def ng_error_messages_for(object_name, method, options = {})
          Tags::NgValidationErrors.new(object_name, method, self, options).render
        end

        def ng_valid(object_name, options, html_options, &block)
          Tags::NgValid.new(object_name, nil, self, options, html_options, '$valid').render(&block)
        end

        def ng_invalid(object_name, options, html_options, &block)
          Tags::NgValid.new(object_name, nil, self, options, html_options, '$invalid').render(&block)
        end

        def ng_valid_for(object_name, method, options, html_options, &block)
          Tags::NgValid.new(object_name, method, self, options, html_options, '$valid').render(&block)
        end

        def ng_invalid_for(object_name, method, options, html_options, &block)
          Tags::NgValid.new(object_name, method, self, options, html_options, '$invalid').render(&block)
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

      end
    end
  end
end
