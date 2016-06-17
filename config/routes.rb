ClearBoxApp::Application.routes.draw do


  #####################################################
  ## Error handling
  #####################################################
  get '/404' => 'errors#not_found'
  get '/500' => 'errors#internal_server_error'
  
  
  #####################################################
  ## Home and Index routing
  #####################################################
  root to: "dashboard#index", constraints: lambda { |r| r.env["warden"].authenticate? }
  root :to => 'home#index', :as => 'home'


  #####################################################
  ## One-off pages
  #####################################################
  get 'home_link' => 'home#index'
  get 'about' => 'about#index'
  get 'case_studies' => 'case_studies#index'
  get 'case_studies/:id' => 'case_studies#show', :as => :case_study
  get 'contact' => 'contact#index'
  get 'portfolio' => 'portfolio#index'
  get 'staff' => 'staff#index'
  get 'dashboard' => 'dashboard#index'


  #####################################################
  ## Resources
  #####################################################
  resources :accounts
  resources :events
  resources :jobs


  #####################################################
  ## Mailer routing
  #####################################################
  post 'mailer/contact_us'  => 'mailer#contact_us'


  #####################################################
  ## Admin
  #####################################################
  namespace :admin do
   get 'dashboard' => 'dashboard#index'
  post 'dashboard' => 'dashboard#update'
  end
  
  
  #####################################################
  ## Profiles
  #####################################################
  get 'profiles/search' => 'profiles#search'
  post 'profiles/search' => 'profiles#search'
  resources :profiles, :except => [:create]

  post 'profiles' => 'profiles#index'
  put 'profiles/:id/admin_update'  => 'profiles#admin_update', :as => :profile_admin_update


  #####################################################
  ## User Photos
  #####################################################
  #resources :user_photos
  post 'user/photos/create' => 'user_photos#create'
  post 'user/photos/crop' => 'user_photos#crop'
  post 'user/photos/destroy' => 'user_photos#destroy'
  post 'user/photos/update' => 'user_photos#update'


  #####################################################
  ## User Videos
  #####################################################
  resources :user_videos, :path => "user/videos" do
    get :autocomplete_credit_title, :on => :collection
    get :autocomplete_profile_name_first, :on => :collection
  end

  post 'user/videos/attach_image' => 'user_videos#attach_image'
  post 'user/videos/attach_video' => 'user_videos#attach_video'
  post 'user/videos/crop' => 'user_videos#crop'
  post 'user/videos/destroy' => 'user_videos#destroy'


  #####################################################
  ## Projects and Tasks
  #####################################################

  get 'projects/search' => 'projects#search'
  post 'projects/search' => 'projects#search'

  resources :projects do
    resources :tasks
  end

  get 'tasks' => 'tasks#index', :as => :tasks

  resources :project_videos, :path => "projects/:project_id/videos" do
    get :autocomplete_credit_title, :on => :collection
    get :autocomplete_profile_name_first, :on => :collection
  end

  post 'projects/:project_id/photos/create' => 'project_photos#create'
  post 'projects/:project_id/photos/crop' => 'project_photos#crop'
  post 'projects/:project_id/photos/destroy' => 'project_photos#destroy'
  post 'projects/:project_id/photos/update' => 'project_photos#update'

  post 'projects/:project_id/videos/attach_image' => 'project_videos#attach_image'
  post 'projects/:project_id/videos/attach_video' => 'project_videos#attach_video'
  post 'projects/:project_id/videos/crop' => 'project_videos#crop'
  post 'projects/:project_id/videos/destroy' => 'project_videos#destroy'


  #####################################################
  ## Invoices
  #####################################################
  get 'invoices/search' => 'invoices#search'
  post 'invoices/search' => 'invoices#search'

  resources :invoices
  get 'invoices/:id/pdf' => 'invoices#pdf'
  post 'invoices/send_invoice'


  #####################################################
  ## Users
  #####################################################
  devise_for :users, :skip => [:registrations, :sessions]

  as :user do

    get 'register' => 'registrations#new', :as => :new_user_registration
    post 'register' => 'registrations#create', :as => :user_registration

    get 'password/edit' => 'devise/registrations#edit', :as => :edit_user_registration
    put 'password/edit' => 'devise/registrations#update', :as => :update_user_registration

    delete 'membership/cancel' => 'devise/registrations#destroy', :as => :destroy_user_registration

    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session

  end


end
