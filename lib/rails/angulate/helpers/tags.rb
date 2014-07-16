module Rails
  module Angulate
    module Helpers
      module Tags
        extend ActiveSupport::Autoload

        eager_autoload do
          autoload :TagCommon
          autoload :NgTextField
          autoload :NgSelect
          autoload :NgTextArea
          autoload :NgEmailField
          autoload :NgValidationErrors
        end
      end
    end
  end
end
