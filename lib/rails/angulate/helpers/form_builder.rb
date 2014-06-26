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

        # ng_invalid_for
        %i{
          ng_form_name
          ng_valid
          ng_valid_for
          ng_invalid
        }.each do |_simple_method|
          define_method _simple_method do |*args, &block|
            @template.send(_simple_method, object, *args, &block)
          end
        end
      end
    end
  end
end
