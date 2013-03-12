Timenote::Application.routes.draw do
  
  match "api/login" => "api#login", :via => :post
  match "api/fetchMonth" => "api#fetchMonth", :via => :post
  match "api/fetchGallery" => "api#fetchGallery", :via => :post
  match "api/uploadPhoto" => "api#upload_photo", :via => :post
  match "api/publish_blog" => "api#publish_blog", :via => :post

  get "mimage/index"

  resources :share

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users, :controllers => {:sessions => 'user/sessions', :registrations => 'user/registrations'}

  match ":domain_name/items/delete/:id" => "items#delete", :as => :delete_item
  match ":domain_name(/:year(/:month(/:day)))" => "items#index", :as => :items, :constraints => {:year => /\d+/, :month => /\d+/}
  match ":domain_name/:year/time/:id" => "items#show", :as => :item, :constraints => {:year => /\d+/}
  match ":domain_name/new" => "items#add", :as => :new_item
  
  match ":domain_name/shares" => "share#index", :as => :shares
  match ":domain_name/share/:hash_string" => "share#show", :as => :share_string

  root :to => 'pages#index'

end
