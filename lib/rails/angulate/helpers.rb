require 'rails/angulate/helpers/form_builder'
require 'rails/angulate/helpers/form_helper'

module Rails
  module Angulate
    module Helpers
      extend ActiveSupport::Concern

      include FormHelper
    end
  end
end
