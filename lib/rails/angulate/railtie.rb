require 'rails'
require 'angulate/helpers'

module Rails
  module Angulate
    class Railtie < ::Rails::Railtie
      initializer :include_helpers do |app|
        ActiveSupport.on_load(:action_view) do
          include Rails::Angulate::Helpers
          cattr_accessor(:default_form_builder) { Rails::Angulate::Helpers::FormBuilder }
        end
      end
    end
  end
end
