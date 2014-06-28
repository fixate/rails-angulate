module Rails
  module Angulate
    class Engine < ::Rails::Engine
      initializer 'angulate.initialize' do
        ActiveSupport.on_load(:action_view) do |base|
          base.send(:include, ::Rails::Angulate::Helpers)
          cattr_accessor(:default_form_builder) { ::Rails::Angulate::Helpers::FormBuilder }
        end
      end

      initializer "angulate.assets.precompile" do |app|
        app.config.assets.precompile += %w(rails/angulate.js)
      end
    end
  end
end
