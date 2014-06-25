module Rails
  module Angulate
    module Helpers
      class FormBuilder < ::ActionView::Helpers::FormBuilder
        # Add prefixed field helpers
        class_attribute :ng_field_helpers
        self.ng_field_helpers = self.field_helpers.map { |f| "ng_#{f}".to_sym }

        def ng_text_field(method, options = {})
          @template.send(
            'ng_text_field',
            @object_name,
            method,
            objectify_options(options)
          )
        end

        def ng_error_messages_for(method, options = {})
          @template.send(
            'ng_error_messages_for',
            @object_name,
            method,
            objectify_options(options)
          )
        end
      end
    end
  end
end
