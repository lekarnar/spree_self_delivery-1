Spree::CheckoutController.class_eval do
  before_action :load_self_delivery_points, :only => [:edit, :update]
  before_action :set_self_delivery_point_id, only: [:update]

  private

  def set_self_delivery_point_id
    if params[:order].present? && params[:order][:shipments_attributes].present?
      shipping_rate_id = params[:order][:shipments_attributes]["0"][:selected_shipping_rate_id].to_i
      shipping_rate = Spree::ShippingRate.where(id: shipping_rate_id).first
      shipping_method_id = shipping_rate.shipping_method.id

      if shipping_method_id == 5
        @order.self_delivery_point_id = "1"
        @order.use_billing = false
      end
    end
  end

  def load_self_delivery_points
    @self_delivery_points = Spree::SelfDeliveryPoint.ordered
  end

  # prevent spree_address_book gem to store user_id in address
  if self.method_defined?(:normalize_addresses)
    spree_address_book_normalize_addresses = instance_method(:normalize_addresses)

    define_method :normalize_addresses do
      if @order.self_delivery?
        return
      else
        spree_address_book_normalize_addresses.bind(self).call
      end
    end
  end
end
