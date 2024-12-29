class CallMessagesController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :set_call_message, only: %i[create]

  def create
    return redirect_to call_path(params[:call_id]) if @call_message.save

    flash[:alert] = t('create_call_message_error')
    redirect_to call_path(params[:call_id])
  end

  private

  def set_call_message
    @call = Call.find(params[:call_id])
    @call_message = CallMessage.new(message: params[:message])
    @call_message.user = current_user
    @call_message.call = @call
  end
end
