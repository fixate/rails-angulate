module Rails
  module Angulate
    module Mappers
      class ValidatorMapper < Base
        def ng_attributes
          {
            "ng-#{mapped_kind}" => true
          }
        end
      end
    end
  end
end


