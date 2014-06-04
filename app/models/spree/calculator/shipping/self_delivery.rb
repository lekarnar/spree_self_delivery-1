require_dependency 'spree/shipping_calculator'

module Spree
  module Calculator::Shipping
    class SelfDelivery < Spree::ShippingCalculator

      def self.description
        I18n.t :self_delivery
      end

      def compute(object)
        object = object.order unless object.kind_of?(Spree::Order)
        object.self_delivery_point.try(:cost) || 0
      end
    end
  end
end
