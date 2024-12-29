module CreationOrdersControllerCommon
  extend ActiveSupport::Concern

  def control_flow
    return unless @creation_order_valid

    @end_process = false

    if params[:back_button]
      @creation_order.previous_step
    elsif @creation_order.last_step?
      @end_process = true
    else
      @creation_order.next_step
    end

    session[:creation_order_step] = @creation_order.current_step
  end

  def decides_next_view
    if @end_process && @creation_order.no_error_found
      session[:creation_order_step] = session[:creation_order_params] = nil
      redirect_to order_path(@order)
    else
      render :new
    end
  end
end
