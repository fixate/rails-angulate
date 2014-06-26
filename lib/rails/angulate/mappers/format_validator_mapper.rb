module Rails
  module Angulate
    module Mappers
      class FormatValidatorMapper < Base
        def ng_attributes
          {}.tap do |attrs|
            if pattern = validator_options[:javascript_format]
              attrs["ng-pattern"] = pattern
            elsif pattern = validator_options[:with]
              attrs["ng-pattern"] = javascriptify_pattern(pattern.source)
            elsif validator_options[:without]
              ActiveSupport::Deprecation.warn(<<-TEXT.strip)
              Angulate does not support validates_format validation using the without option.
              Use the 'with' and/or 'javascript_format' options instead.
              TEXT
            end
          end
        end

        private

        ##
        # Will only work with simple regexes that happen to match javascript.
        # Replaces leading \A and trailing \z with ^ and $ respectively
        def javascriptify_pattern(pattern)
          pattern.gsub!(/^\\A/, '^')
          pattern.gsub!(/\\z$/, '$')
          "/#{pattern}/"
        end
      end
    end
  end
end

