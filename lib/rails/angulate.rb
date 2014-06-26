require 'rails'
require 'active_support'

require 'rails/angulate/version'
require 'rails/angulate/configuration'
require 'rails/angulate/helpers'
require 'rails/angulate/mappers'
require 'rails/angulate/engine'

module Rails
  module Angulate
    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield configuration
    end
  end
end

