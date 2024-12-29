class ResponseHelper
  class << self
    def error(msg)
      { status: 'ERROR_API', status_message: msg, data: {} }
    end

    def success(data)
      { status: 'SUCCESS', status_message: 'OK', data: }
    end

    def not_found(msg)
      { status: 'NOT_FOUND', status_message: msg, data: {} }
    end
  end
end
