module Rails
  module Angulate
    class Engine < ::Rails::Engine
      initializer 'angulate.initialize' do
        ActiveSupport.on_load(:action_view) do |base|
          base.send(:include, ::Rails::Angulate::Helpers)
          cattr_accessor(:default_form_builder) { ::Rails::Angulate::Helpers::FormBuilder }
        end
      end
    end
  end
end
