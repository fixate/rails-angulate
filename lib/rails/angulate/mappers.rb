require 'rails/angulate/mappers/base'
require 'rails/angulate/mappers/validator_mapper'
require 'rails/angulate/mappers/length_validator_mapper'
require 'rails/angulate/mappers/format_validator_mapper'

module Rails
  module Angulate
    module Mappers
      @@lock = Mutex.new
      @@constants = {}

      def self.register_constant(kind, constant)
        @@lock.synchronize do
          @@constants[kind.to_sym] = constant
        end
      end

      def self.create_validator_mapper_for(model, attribute_name,  validator)
        @@lock.synchronize do
          if klass = @@constants[validator.kind]
            klass.new(model, attribute_name, validator)
          else
            # General purpose mapper
            ValidatorMapper.new(model, attribute_name, validator)
          end
        end
      end

      register_constant('length', LengthValidatorMapper)
      register_constant('format', FormatValidatorMapper)
    end
  end
end
