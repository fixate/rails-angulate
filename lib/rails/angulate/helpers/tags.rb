module Rails
  module Angulate
    module Helpers
      module Tags
        extend ActiveSupport::Autoload

        eager_autoload do
          autoload :NgTextField
          autoload :NgValidationErrors
        end
      end
    end
  end
end
