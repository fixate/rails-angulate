module Rails
  module Angulate
    module Helpers
      module Tags
        class NgTextField < ActionView::Helpers::Tags::TextField
          def render
            options = @options.stringify_keys
            options["size"] = options["maxlength"] unless options.key?("size")
            options["type"] ||= field_type
            options["value"] = options.fetch("value") { value_before_type_cast(object)  } unless field_type == "file"
            options["value"] &&= ERB::Util.html_escape(options["value"])

            add_default_name_and_id(options)
            set_ng_options(options)

            tag("input", options)
          end

          def set_ng_options(options)
            if options.has_key?("ng")
              options.delete("ng").each do |k, v|
                options["ng-#{k}"] = v
              end
            end

            options["ng-model"] = (options.fetch("ngModel") { ngModelName(options["id"]) }).to_s unless options.has_key?("ng-model")
          end

          def ngModelName(id)
            id.camelize(:lower)
          end

          def self.field_type
            @field_type ||= super.sub(/^ng/, '')
          end
        end
      end
    end
  end
end