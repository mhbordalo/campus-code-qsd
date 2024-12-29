module DashboardControllerMethods
  extend ActiveSupport::Concern

  def check_filter_in_use
    @all_salesman = @filter_activated = false
    @salesman = current_user

    return unless current_user.admin?

    check_filter_in_use_admin
  end

  def check_filter_in_use_admin
    if params[:salesman_id].present? && params[:salesman_id] != ''
      @salesman = @salesmen_list.select { |salesman| salesman.id == params[:salesman_id].to_i }.first
      @filter_activated = true
    else
      @all_salesmen = true
    end
  end

  def orders_status_data
    orders_day = orders_status_day_data
    @orders_day_by_status = Order.statuses.to_h { |k, _v| [I18n.t(k), orders_day[k] || 0] }
    @orders_day_by_status_sum = sum_all_integers(@orders_day_by_status)

    orders_month = orders_status_month_data
    @orders_month_by_status = Order.statuses.to_h { |k, _v| [I18n.t(k), orders_month[k] || 0] }
    @orders_month_by_status_sum = sum_all_integers(@orders_month_by_status)
  end

  def orders_status_day_data
    day_range = Time.zone.today.all_day
    if @all_salesmen
      Order.where(created_at: day_range)
           .group(:status).count
    else
      @salesman.orders.where(created_at: day_range)
               .group(:status).count
    end
  end

  def orders_status_month_data
    if @all_salesmen
      Order.where(created_at: month_range)
           .group(:status).count
    else
      @salesman.orders.where(created_at: month_range)
               .group(:status).count
    end
  end

  def orders_products_data
    @orders_month_by_product = orders_products_month_data
    @orders_month_by_product_sum = sum_all_integers(@orders_month_by_product)
  end

  def orders_products_month_data
    if @all_salesmen
      Order.where(created_at: month_range)
           .group(:product_group_name).count
    else
      @salesman.orders.where(created_at: month_range)
               .group(:product_group_name).count
    end
  end

  def orders_periodicity_data
    @orders_month_by_periodicity = orders_periodicity_month_data
    @orders_month_by_periodicity_sum = sum_all_integers(@orders_month_by_periodicity)
  end

  def orders_periodicity_month_data
    if @all_salesmen
      Order.where(created_at: month_range)
           .group(:product_plan_periodicity).count
    else
      @salesman.orders.where(created_at: month_range)
               .group(:product_plan_periodicity).count
    end
  end

  def orders_sales_data
    @orders_sales_month_by_day = sum_sales_grouped_by_date('%d', orders_sales_month_data)

    @orders_sales_month_by_day_sum = 0
    @orders_sales_month_by_day.map do |_day, sales|
      @orders_sales_month_by_day_sum += sales
    end
  end

  def orders_sales_month_data
    if @all_salesmen
      Order.paid.where(created_at: month_range)
    else
      @salesman.orders.paid.where(created_at: month_range)
    end
  end

  def sum_all_integers(array)
    array.flatten.grep(Integer).reduce(:+)
  end

  def sum_sales_grouped_by_date(grouping, items)
    data = items.group_by { |x| x.created_at.to_date.strftime(grouping) }
    chart_data = {}

    data.each do |a, b|
      amount = b.inject(0) { |sum, hash| sum + (hash[:price] - hash[:discount]) }
      chart_data.merge!({ a => amount })
    end

    chart_data
  end

  def day_range
    Time.zone.today.at_beginning_of_day..Time.zone.today.end_of_day
  end

  def month_range
    Time.zone.today.at_beginning_of_month..Time.zone.today.end_of_month
  end
end
