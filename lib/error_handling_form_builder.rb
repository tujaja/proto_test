module ActionView
  module Helpers
    class InstanceTag
      def error_wrapping(html_tag, has_error)
        #has_error ? Base.field_error_proc.call(html_tag, self) : html_tag
        html_tag
      end
    end
  end
end


class ErrorHandlingFormBuilder < ActionView::Helpers::FormBuilder

  helpers = field_helpers +
    %w(date_select datetime_select time_select) -
    %w(hidden_field label fields_for)

  helpers.each do |name|
    define_method(name) do |field, *args|
      infos = args.last.is_a?(Hash) ? args.pop : {}
      options = args.last.is_a?(Hash) ? args.pop : {}

      #if %w(text_field password_field).include?(name) && required_field?(field)
        #options[:onblur] = "checkPresence('#{field_name(field)}')"
      #end

      build_shell(field, options, infos) do |f, o|
        super(f, o)
      end
    end
  end

  def build_shell(field, options, infos)
    @template.capture do
      descs = [infos[:descs]].flatten
      label_name = required_mark(field) + infos[:name]

      locals = {
        :element => yield(field, options),
        :label => label(field, label_name),
        :descs => descs
      }
      if has_errors_on?(field)
        locals.merge!(:errors => error_messages(field, options))
        @template.render :partial => 'admin/forms/field_with_errors', :locals => locals
      else
        @template.render :partial => 'admin/forms/field', :locals => locals
      end
    end
  end

  private
    def field_name(field)
      # @object_nameってなに？
      "#{@object_name.to_s.underscore}_#{field.to_s.underscore}"
    end

    def label_text(field)
     "#{field.to_s.humanize}"
    end

    def required_mark(field)
      required_field?(field) ? ' <span>*</span> ' : ''
    end

    def required_field?(field)
      @object_name.to_s.camelize.constantize.
                   reflect_on_validations_for(field).
                   map(&:macro).include?(:validates_presence_of)
    end

    def error_messages(field, options)
      if has_errors_on?(field)
        errors = object.errors.on(field)
        #errors.is_a?(Array) ? errors.to_sentence : errors
      else
        []
      end
    end

    def has_errors_on?(field)
      !(object.nil? || object.errors.on(field).blank?)
    end
end
