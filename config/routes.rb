Rails.application.routes.draw do
  namespace :api do
    post "auth/request_otp", to: "auth#request_otp"
    post "auth/verify_otp", to: "auth#verify_otp"
    post "auth/admin_login", to: "auth#admin_login"

    post "public_users/request_otp", to: "public_users#request_otp"
    post "public_users/verify_otp", to: "public_users#verify_otp"
    get "public_users/profile", to: "public_users#profile"
    patch "public_users/profile", to: "public_users#update_profile"
    get "public_users/requests", to: "public_users#requests"

    get "public_requests/:id/track", to: "public_requests#track"

    namespace :admin do
      resource :profile, only: %i[show update]
      resources :requests do
        collection do
          get :assigned_to_me
        end
        member do
          patch :assign
          patch :status
          patch :severity
        end
      end
      get "assignable_users", to: "requests#assignable_users"
    end

    namespace :public do
      get "home", to: "home#index"
      get "profile", to: "profile#show"
      get "campaigns", to: "campaigns#index"
      get "campaigns/:id", to: "campaigns#show"
      get "pr_posts", to: "pr_posts#index"
      get "pr_posts/:id", to: "pr_posts#show"
      get "work_dones/:id", to: "work_dones#show"
      resources :requests, only: %i[create update] do
        member do
          get :status
        end
      end
      resources :campaign_supports, only: %i[create]
      post "signup", to: "registrations#create"
    end

    resources :vidhansabhas
    resources :areas
    resources :village_wards
    resources :population_records
    resources :work_dones
    resources :public_requests
    resources :campaigns
    resources :pr_posts
    resources :users
    resources :permissions, only: [:index]
    resources :role_permissions, only: %i[index create destroy]

    post "otp/send", to: "otp#send_otp"
    post "otp/verify", to: "otp#verify_otp"
    post "otp/register", to: "otp#register"

    get "analytics/summary", to: "analytics#summary"

    resources :notifications, only: [:index] do
      member do
        patch :read, to: "notifications#mark_read"
      end
      collection do
        patch :mark_all_read, to: "notifications#mark_all_read"
        get :unread_count, to: "notifications#unread_count"
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
