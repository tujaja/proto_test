ActionController::Routing::Routes.draw do |map|

  map.store "/", :controller => 'store', :action => 'index'
  map.admin "/admin", :controller => 'admin', :action => 'index'
  map.logout '/admin/logout', :controller => 'admin/sessions', :action => 'destroy'
  map.login '/admin/login', :controller => 'admin/sessions', :action => 'new'
  map.download '/download/:id', :controller => 'download', :action => 'show'
  map.file '/file/:id', :controller => 'file', :action => 'download'

  map.resources :contents
  map.resources :artists
  map.resources :labels

  map.resource :cart
  map.resource :order
  map.resource :payment

  map.namespace :admin do |admin|
    admin.resources :contents
    admin.resources :artists
    admin.resources :labels
    admin.resources :images
    admin.resources :downloads
    admin.resource  :session
    admin.resources :users
    admin.resources :orders
  end


  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
