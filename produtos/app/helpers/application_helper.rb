module ApplicationHelper
  def link_to_show(path)
    link_to path, class: 'ls-sm-margin-right ls-tooltip-top-left', aria: { label: t('show') } do
      '<span class="ls-ico-eye" style="font-size: 1.2rem"></span>'.html_safe
    end
  end

  def link_to_edit(path)
    link_to path, class: 'ls-sm-margin-right ls-tooltip-top-left', aria: { label: t('edit') } do
      '<span class="ls-ico-edit-admin" style="font-size: 1.2rem"></span>'.html_safe
    end
  end

  def btn_new(path)
    link_to t('crud.action.new'), path, class: 'ls-btn ls-btn-sm'
  end
end
