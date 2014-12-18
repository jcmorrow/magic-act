Rails.application.routes.draw do
  devise_for :admins
  get '/admins' => 'admins#index'
  resources :jobs
  get '/job/:id/count' => 'jobs#queryCount'
  post '/job/:id/run' => 'jobs#run'
  get '/download/:sub_job_id/:file_type', to: 'downloads#secureGet', as: 'secure_get'
#  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  get '/object_rules/explore' => 'object_rules#explore'

  root 'home#index'
  resources :object_rules do
    resources :field_rules
  end


  #DELAYEDJOBWEB
  authenticated :admin do
    mount DelayedJobWeb, :at => "/delayed_job"
  end
  #RAILS ADMIN
  mount RailsAdmin::Engine => '/admin/', as: 'rails_admin'

end