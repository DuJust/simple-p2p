Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :accounts, only: [:create]
      post 'transactions/loan', to: 'transactions#loan'
    end
  end
end
