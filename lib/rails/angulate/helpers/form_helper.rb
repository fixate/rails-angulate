require 'rails/angulate/helpers/tags'

module Rails
  module Angulate
    module Helpers
      module FormHelper
        extend ActiveSupport::Concern

        def ng_form_for(record, options = {}, &block)
          options[:html] ||= {}
          options[:html][:name] ||= options[:as] || form_name_from_record_or_class(record)
          form_for(record, options, &block)
        end

        def ng_text_field(object_name, method, options = {})
          Tags::NgTextField.new(object_name, method, self, options).render
        end

        def ng_error_messages_for(object_name, method, options = {})
          Tags::NgValidationErrors.new(object_name, method, self, options).render
        end

        def form_name_from_record_or_class(record)
          object_name = case record
          when String, Symbol
            record
          else
            object = record.is_a?(Array) ? record.last : record
            raise ArgumentError, "First argument in form cannot contain nil or be empty" unless object
            model_name_from_record_or_class(object).param_key
          end

          "#{object_name}_form"
        end
      end
    end
  end
end
