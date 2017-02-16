Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :accounts, only: [:create, :show] do
        collection do
          get :debt
        end
      end
      post 'transactions/loan', to: 'transactions#loan'
      post 'transactions/repay', to: 'transactions#repay'
    end
  end

  get 'docs/index', to: 'docs#index'
end
