module PlansHelper
  def plan_status(status, msg)
    class_status = 'ls-tag-primary' if status == 'active'
    class_status = 'ls-tag-warning' if status == 'discontinued'
    content_tag('span', msg, class: class_status)
  end
end
