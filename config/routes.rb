Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/users/register', action: :register_user, controller: 'first_zombie_apocalypses'
    end
  end
end
