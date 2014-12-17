Rails.application.routes.draw do
  devise_for :admins
  get '/admins' => 'admins#index'
  mount RailsAdmin::Engine => '/admin/', as: 'rails_admin'
  resources :jobs
  get '/job/:id/count' => 'jobs#queryCount'
  post '/job/:id/run' => 'jobs#run'
  get '/download/:sub_job_id/:file_type', to: 'downloads#secureGet', as: 'secure_get'
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  get '/object_rules/explore' => 'object_rules#explore'

  root 'home#index'
  resources :object_rules do
    resources :field_rules
  end

end