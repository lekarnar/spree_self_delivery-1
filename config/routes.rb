Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :self_delivery_points do
      collection do
        post :update_positions
      end
    end
  end
end
