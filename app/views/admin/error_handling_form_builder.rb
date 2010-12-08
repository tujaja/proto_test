class ErrorHandlingFormBuilder < ActionView::Helpers::FormBuilder

  helpers = field_helpers

  helpers.each do |name|
    define_method name do |field, *args|
      options = args.detect {|argument| argument.is_a?(Hash) || {}
        build_shell(field, options) do
          super
        end
    end
  end

end
