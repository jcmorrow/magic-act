Rails.application.routes.draw do
  devise_for :admins
  get '/admins' => 'admins#index'
  mount RailsAdmin::Engine => '/admin/', as: 'rails_admin'
  resources :etl_jobs
  get '/etl-job/:id/count' => 'etl_jobs#queryCount'
  post '/etl-job/:id/run' => 'etl_jobs#run'
  get '/download/:sub_job_id/:file_type', to: 'downloads#secureGet', as: 'secure_get'
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]


  root 'home#index'
  resources :etl_object_rules do
    resources :etl_field_rules
  end



  #THROWING IN SOME OTHER STUFF, HOPING THIS CAN ALL BE ONE APPLICATION
  post '/paypal/webhook/', to: 'paypal_webhooks#webhook'
end