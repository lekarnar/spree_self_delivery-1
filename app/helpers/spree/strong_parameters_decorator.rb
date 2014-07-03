Spree::Core::ControllerHelpers::StrongParameters.class_eval do

  def permitted_checkout_attributes
    permitted_attributes.checkout_attributes + [
      :bill_address_attributes => permitted_address_attributes,
      :ship_address_attributes => permitted_address_attributes,
      :payments_attributes => permitted_payment_attributes,
      :shipments_attributes => permitted_shipment_attributes
    ] << :self_delivery_point_id
  end

end
