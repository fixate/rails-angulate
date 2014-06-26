module Rails
  module Angulate
    module Helpers
      module Tags
        module TagCommon
          extend ActiveSupport::Concern
          include Forwardable

          protected

          delegate :configuration, to: Rails::Angulate

          def angular_form_object_name
            @template_object.ng_form_name(object)
          end

          def angular_form_field_object_name
            @template_object.ng_form_field_name(object, @method_name)
          end

          def validators
            @validators ||=
              object.class.validators.select { |v| v.attributes.include?(@method_name.to_sym) }
          end

          def validator_mapper_for(validator)
            Rails::Angulate::Mappers.create_validator_mapper_for(object, @method_name, validator)
          end
        end
      end
    end
  end
end
