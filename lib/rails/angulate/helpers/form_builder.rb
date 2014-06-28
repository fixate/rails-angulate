module Rails
  module Angulate
    module Helpers
      class FormBuilder < ::ActionView::Helpers::FormBuilder
        # Add prefixed field helpers
        class_attribute :ng_field_helpers
        self.ng_field_helpers = self.field_helpers.map { |f| "ng_#{f}".to_sym }

        %i{
          ng_text_field
          ng_text_area
          ng_email_field
          ng_error_messages_for
        }.each do |_adv_method|
          define_method _adv_method do |*args, &block|
            options = args.extract_options!
            options = objectify_options(options)
            @template.send(_adv_method, @object_name, *args, options, &block)
          end
        end

        %i{
          ng_form_name
          ng_valid
          ng_valid_for
          ng_invalid_for
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
