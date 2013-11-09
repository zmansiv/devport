Devport::Application.routes.draw do
  resources :users, only: [:edit], defaults: { format: :html }

  resources :sessions, only: [:index], defaults: { format: :html }
  resources :sessions, only: [:create, :destroy], defaults: { format: :json }
  delete "sessions", to: "sessions#destroy", as: :sessions, only: [:delete], defaults: { format: :json }
  get "auth/github", as: :signin, defaults: { format: :html }
  get "auth/linked", as: :linkedin_auth, defaults: { format: :html }
  get "auth/:provider/callback", to: "sessions#create", as: :auth, defaults: { format: :json }
  get "auth/failure", to: "sessions#failure", as: :failed_auth, defaults: { format: :json }

  namespace :api, defaults: { format: :json } do
    resources :users, only: [:index, :show, :update, :destroy], defaults: { format: :json }
    delete "user/:id/:provider", to: "users#destroy_provider", as: :destroy_provider, defaults: { format: :json }
    put "user/:id/:provider", to: "users#sync_provider", as: :sync_provider, defaults: { format: :json }
    post "user/:id/projects/reorder", to: "projects#reorder", as: :reorder_projects, defaults: { format: :json }
    delete "user/:id/projects/:project_name", to: "projects#destroy", as: :project, defaults: { format: :json }
    post "user/:id/projects/:project_name/images", to: "images#create", as: :project_images, defaults: { format: :json }
  end

  get "about", to: "pages#about", as: :about, defaults: { format: :html }
  get "stats", to: "pages#stats", as: :stats, defaults: { format: :html }

  get ":id", to: "users#show", as: :user, defaults: { format: :html }

  root to: "pages#home"
end