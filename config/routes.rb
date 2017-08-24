Rails.application.routes.draw do
  resource :invoice, only: [:create]
end
