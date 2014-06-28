module Rails
  module Angulate
    module Helpers
      module Tags
        class NgTextField < ActionView::Helpers::Tags::TextField
          include TagCommon

          def render
            options = @options.stringify_keys
            options["size"] = options["maxlength"] unless options.key?("size")
            options["type"] ||= field_type
            options["value"] = options.fetch("value") { value_before_type_cast(object)  } unless field_type == "file"
            options["value"] &&= ERB::Util.html_escape(options["value"])

            add_default_name_and_id(options)
            add_ng_options(options)
            add_ng_model(options)
            add_ng_validation_attrs(options)

            tag 'input', options
          end
        end
      end
    end
  end
end
