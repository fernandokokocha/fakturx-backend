Rails.application.routes.draw do
  resources :invoice, only: [:index, :create]
end
