require 'rails/angulate/mappers/base'

module Rails
  module Angulate
    module Mappers
      @@lock = Mutex.new
      @@mappers = {}

      def self.register_mapper(constant, kind = nil)
        @@lock.synchronize do
          if kind.nil?
            kind = constant.name.split('::').last
              .sub('ValidatorMapper', '').underscore
          end

          @@mappers[kind.to_sym] = constant unless kind.blank?
        end
      end

      def self.create_validator_mapper_for(model, attribute_name,  validator)
        @@lock.synchronize do
          if klass = @@mappers[validator.kind]
            klass.new(model, attribute_name, validator)
          else
            # General purpose mapper
            ValidatorMapper.new(model, attribute_name, validator)
          end
        end
      end

    end
  end
end

require 'rails/angulate/mappers/validator_mapper'
require 'rails/angulate/mappers/length_validator_mapper'
require 'rails/angulate/mappers/format_validator_mapper'
require 'rails/angulate/mappers/numericality_validator_mapper'

