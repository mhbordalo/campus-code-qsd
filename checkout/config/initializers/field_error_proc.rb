# config/initializers/field_error_proc.rb

module ActiveModel::Conversion
  attr_accessor :skip_field_error_wrapper
end

ActionView::Base.field_error_proc = Proc.new {|html_tag, instance|
  if instance.object && instance.object.skip_field_error_wrapper
    html_tag.html_safe
  else
    "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe
  end
}