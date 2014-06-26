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
      # submitted: only once the user has submitted the form
      attr_accessor :validate_on

      attr_accessor :validate_show_condition

      def initialize
        self.validate_on = %i{ blur }
        self.validate_show_condition = "%{field}.$invalid && (%{validate_on})"
      end

      def validator_mappings
        @validator_mappings ||= {
          presence: 'required',
          format: 'pattern',
          length: 'maxlength'
        }
      end

    end
  end
end
