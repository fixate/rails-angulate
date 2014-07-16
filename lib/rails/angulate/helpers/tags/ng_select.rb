module Rails
  module Angulate
    module Helpers
      module Tags
        class NgSelect < ActionView::Helpers::Tags::Select
          include TagCommon

          def render
            option_tags_options = {
              :selected => @options.fetch(:selected) { value(@object) },
              :disabled => @options[:disabled]
            }

            option_tags = if grouped_choices?
              grouped_options_for_select(@choices, option_tags_options)
            else
              options_for_select(@choices, option_tags_options)
            end

            add_default_name_and_id(@options)
            add_ng_options(@options)
            add_ng_model(@options)
            add_ng_validation_attrs(@options)

            select_content_tag(option_tags, @options, @html_options)
          end
        end
      end
    end
  end
end
