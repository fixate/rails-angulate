module Rails
  module Angulate
    module Helpers
      module Tags
        module TagCommon
          extend ActiveSupport::Concern
          include Forwardable

          protected

          delegate :configuration, to: Rails::Angulate

          def validators
            if object.nil?
              raise RuntimeError.new(<<-TEXT.strip)
                Form helper object is nil. If this is an association
                make sure that you accept_nested_attributes_for :assocation
                so that validations for nested attributes can be determined.
              TEXT
            end

            @validators ||= object.class.validators.select do |v|
              v.attributes.include?(@method_name.to_sym)
            end
          end

          def add_ng_validation_attrs(attrs)
            validators.each do |validator|
              attrs.reverse_merge!(validator_mapper_for(validator).ng_attributes)
            end
          end

          def validator_mapper_for(validator)
            Rails::Angulate::Mappers.create_validator_mapper_for(object, @method_name, validator)
          end

          def add_ng_options(options)
            if options.has_key?("ng")
              options.delete("ng").each do |k, v|
                options["ng-#{k}"] = v
              end
            end
          end

          def add_ng_model(options)
            unless options.has_key?("ng-model")
              options["ng-model"] = options.fetch("ngModel") do
                name = options["id"] || options["name"]
                ng_model_name(name)
              end.to_s
            end
          end

          def ng_model_name(name)
            name.camelize(:lower)
          end

          def form_object_name
            "#{@object_name.gsub(/\[.+\]/, '')}_form"
          end

          def form_field_object_name
            "#{form_object_name}['#{field_name}']"
          end

          def field_name
            @field_name ||= begin
              names = {}
              add_default_name_and_id(names)
              names['name']
            end
          end

          module ClassMethods
            def field_type
              @field_type ||= super.sub(/^ng/, '')
            end
          end
        end
      end
    end
  end
end
