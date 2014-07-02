class AddCompanyToSelfDeliveryPoints < ActiveRecord::Migration
  def change
    add_column :spree_self_delivery_points, :company, :string
  end
end
