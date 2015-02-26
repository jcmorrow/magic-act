Rails.application.routes.draw do
  devise_for :admins

  get '/admins' => 'admins#index'
  get '/job/:id/count' => 'jobs#queryCount'
  post '/job/:id/run' => 'jobs#run'
  get '/download/:sub_job_id/:file_type', to: 'downloads#secureGet', as: 'secure_get'
  get '/visualizations/', to: 'visualizations#index', as: 'visualizations'
  post '/query/', to: 'visualizations#query', as: 'query'

  get '/feeds/actions/:id', to: 'feeds#actions', as: 'action_feed'

  root 'home#index'
  resources :jobs
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