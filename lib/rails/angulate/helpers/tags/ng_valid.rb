module Rails
  module Angulate
    module Helpers
      module Tags
        class NgValid < ActionView::Helpers::Tags::Base
          include TagCommon
          attr_accessor :output_buffer

          def initialize(object_name, method, template_object, options, html_options, qualifier)
            @html_options = html_options
            @qualifier = qualifier
            @output_buffer = ActionView::OutputBuffer.new

            super(object_name, method, template_object, options)
          end

          def render(&block)
            object_name = @method_name.nil? ?  form_object_name : form_field_object_name

            content = ''
            content = @template_object.capture(&block) if block_given?
            content_tag :span, content, 'ng-show' => "#{object_name}.#{@qualifier}"
          end
        end
      end
    end
  end
end
