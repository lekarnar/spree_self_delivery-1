Spree::Order.class_eval do

  belongs_to :self_delivery_point

  define_method :has_available_shipment do
    if self_delivery?
      return
    else
      spree_has_available_shipment.bind(self).call
    end
  end

  spree_has_available_shipment = instance_method(:has_available_shipment)

  before_validation :set_ship_address

  state_machine do
    before_transition :to => :delivery do |order|
      if order.self_delivery?
        #order.shipping_method = nil
        order.save
      end
    end

    after_transition :to => :delivery do |order|
      if order.self_delivery?
        order.state = order.payment_required? ? :payment : :complete
        order.save
        order.state == "payment" ? order.force_shippment_method_to_self_delivery : order.finalize!
        #order.finalize!
      end
    end
  end

  def self_delivery_point_id=(point_id)
    @self_delivery_point_id = point_id
  end

  def self_delivery?
    !@self_delivery_point_id.nil?

    # if (defined? shipments.first.shipping_method).nil?
    #   false
    # elsif !self_delivery_point_id.nil?
    #   shipping_method = Spree::ShippingMethod.where(id: shipments.first.shipping_method.id).first
    #   shipping_method && shipping_method.self_delivery?
    # end
  end

  def force_shippment_method_to_self_delivery
    shipments.each do |s|
      s.shipping_methods.delete_all
      s.add_shipping_method(Spree::ShippingMethod.self_delivery, true)
      s.save
    end
  end


  private

  def set_ship_address
    if self.state == "delivery" || self.state == "address"
      if self_delivery?
        if @self_delivery_point_id

          write_attribute(:self_delivery_point_id, @self_delivery_point_id)
          return if @self_delivery_point_id.to_i < 1 || !ship_address

          if ship_address_id == bill_address_id
            new_ship_address = Spree::Address.new
            set_ship_address_params(new_ship_address, true)
          else
            set_ship_address_params(ship_address, false)
          end
        end
      end
    end
  end

  def set_ship_address_params(ship_address_var, is_new_ship_addres)

    if is_new_ship_addres || (use_billing_self? && bill_address)
      [:firstname, :lastname, :phone].each do |a|
        ship_address_var.send("#{a}=", bill_address.send(a))
      end
    end

    if sdp = Spree::SelfDeliveryPoint.find_by_id(@self_delivery_point_id)
      [:country, :state, :state_name, :city, :address1].each do |a|
        ship_address_var.send("#{a}=", sdp.send(a))
      end
      ship_address_var.zipcode = 1000

      if is_new_ship_addres
        ship_address_var.save!
        self.ship_address = ship_address_var
      end

      shipments = self.create_proposed_shipments
      shipments.each do |s|
        self_shiping_rate = s.shipping_rates.find_by_shipping_method_id(Spree::ShippingMethod.self_delivery.id)
        s.selected_shipping_rate_id = self_shiping_rate.id
      end
    end

  end

end
