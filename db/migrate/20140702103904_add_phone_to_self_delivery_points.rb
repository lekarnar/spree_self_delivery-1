class AddPhoneToSelfDeliveryPoints < ActiveRecord::Migration
  def change
    add_column :spree_self_delivery_points, :phone, :string
  end
end
