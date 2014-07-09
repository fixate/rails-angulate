module Rails
  module Angulate
    module Mappers
      class ValidatorMapper < BaseMapper
        def ng_attributes
          {
            "ng-#{mapped_kind}" => true
          }
        end
      end
    end
  end
end


