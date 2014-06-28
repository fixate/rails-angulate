module Rails
  module Angulate
    module Helpers
      module Tags
        class NgTextArea < ActionView::Helpers::Tags::Base
          include TagCommon

          def render
            options = @options.stringify_keys
            add_default_name_and_id(options)

            if size = options.delete("size")
              options["cols"], options["rows"] = size.split("x") if size.respond_to?(:split)
            end

            add_ng_options(options)
            add_ng_model(options)
            add_ng_validation_attrs(options)

            content_tag("textarea", options.delete("value") { value_before_type_cast(object) }, options)
          end

        end
      end
    end
  end
end
