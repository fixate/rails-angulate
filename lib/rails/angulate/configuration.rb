module Rails
  module Angulate
    class Configuration
      attr_writer :validator_mappings
      ##
      # Set on what conditions do you want the validation messages to show
      #
      # Possible values:
      # blur: only once the field has been visited
      # dirty: only if the field is dirty
      # submit_attempt: only once the user has submitted the form
      attr_accessor :validate_on, :default_error_classes, :validate_show_condition

      def initialize
        self.validate_on = { submit_attempt: :or, blur: nil }
        self.validate_show_condition = "%{field}.$invalid && (%{validate_on})"
        self.default_error_classes = []
      end

      def validator_mappings
        @validator_mappings ||= {
          presence: 'required',
          format: 'pattern',
          length: 'maxlength'
        }
      end

      def add_mapper(name, mapper_class)
        Rails::Angulate::Mappers.register_mapper(name, mapper_class)
      end
    end
  end
end
