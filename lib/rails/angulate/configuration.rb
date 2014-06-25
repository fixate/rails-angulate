module Rails
  module Angulate
    class Configuration
      attr_writer :validator_mappings

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
