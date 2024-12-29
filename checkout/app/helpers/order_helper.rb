module OrderHelper
  ORDER_STATUS_TAG = { pending: 'ls-tag-warning', awaiting_payment: 'ls-tag-info', cancelled: 'ls-tag-danger',
                       paid: 'ls-tag-success' }.freeze

  def tag_status(status)
    ORDER_STATUS_TAG[status]
  end
end
