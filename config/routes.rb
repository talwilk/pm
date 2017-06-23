Rails.application.routes.draw do
  devise_for :super_admin

  namespace :super_admin do
    root to: 'dashboard#index'
    resources :super_admins, only: [:index, :new, :edit, :create, :update, :destroy] do
      member do
        patch :bring_back
      end
    end

    resources :guru_invitations, only: [:index, :new, :create]

    resources :country_management, only: [:index], controller: 'country_management', param: :country_iso do
      collection do
        get :enable
        get :disable
      end
    end
    resources :guru_applications do
      member do
        patch :start_guru_application_review
        patch :reject_guru_application
        patch :accept_guru_application
      end
    end
    resources :users do
      member do
        get :sign_in_as_user
      end
      resources :grant_points, only: [:new, :create]
    end
    resources :blog
    resources :dilemmas
    resources :dilemma_advices
    resources :media, only: [:destroy]
  end

  namespace :blog do
    resources :posts, only: [:index, :show]
  end

  devise_for :users, :controllers => {
                                        :omniauth_callbacks => 'omniauth_callbacks',
                                        :registrations => 'registrations',
                                        :sessions => 'sessions',
                                        :confirmations => 'confirmations',
                                        :passwords => 'passwords'
                                      }
  devise_scope :user do
    get 'users/confirmation/resend_token', to: 'confirmations#resend_token'
  end
  resource :profile, only: [:edit, :update], controller: 'user_profile' do
    delete :remove_avatar
  end
  resources :users, only: [:index, :show]
  resources :dilemmas do
    resources :advices, only: [:create], controller: 'dilemma_advices' do
      member do
        get :favorite
        put :like
      end
    end
    member do
      delete :remove_media
      get :set_cover_photo
    end
  end
  resource :payment_plan_transaction, controller: 'payment_plan_transaction'

  authenticated :user do
    #root to: 'users#dashboard'
    root to: 'users#dashboard_project'
  end

  authenticated :super_admin do
    root to: 'home#index', as: :unauthenticated_root_super_admin
  end

  unauthenticated do
    root to: 'landing#user', as: :unauthenticated_root
  end

  get '/gamification', to: 'gamification#index'

  resources :guru_registrations

  resources :wizard 
  resources :projects do
    resources :tasks do
      resources :pros do
        post :assign_task, on: :collection
      end
    end 
  end

  post "/new_professional", to: "pros#new_professional"

  post "/update_task/:id", to: "tasks#update_task"

  

  get '/user', to: 'landing#user'
  get '/guru', to: 'landing#guru'
  get '/about', to: 'landing#about'
  get '/pricing', to: 'pricing#index'
  get '/', to: 'landing#user'
end
