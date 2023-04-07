Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/users/register', action: :register_user, controller: 'first_zombie_apocalypses'
      patch '/users/:id/update_location', action: :update_location, controller: 'first_zombie_apocalypses'
      patch '/users/:id/update_inventory', action: :update_inventory, controller: 'first_zombie_apocalypses'
      patch '/users/perform_barter', action: :perform_barter, controller: 'first_zombie_apocalypses'
      patch '/users/warn_infection', action: :warn_infection, controller: 'first_zombie_apocalypses'
    end
  end
end
