ActionController::Routing::Routes.draw do |map|

  map.store "/", :controller => 'store', :action => 'index'
  map.info "/info", :controller => 'store', :action => 'info'
  map.about "/about", :controller => 'store', :action => 'about'
  map.term "/term", :controller => 'store', :action => 'term'
  map.help "/help", :controller => 'store', :action => 'help'
  map.company "/company", :controller => 'store', :action => 'company'
  map.privacy "/privacy", :controller => 'store', :action => 'privacy'

  map.download '/download/:token', :controller => 'download', :action => 'show'
  map.file '/file/:token', :controller => 'file', :action => 'download'

  map.admin        '/admin',        :controller => 'admin', :action => 'index'
  map.admin_logout '/admin/logout', :controller => 'admin/sessions', :action => 'destroy'
  map.admin_login  '/admin/login',  :controller => 'admin/sessions', :action => 'new'
  map.admin_mails  '/admin/mail',  :controller => 'admin/mails', :action => 'index'
  map.admin_mails_send  '/admin/mail/send_mail',  :controller => 'admin/mails', :action => 'send_mail'

  map.admin_label_images '/admin/labels/:id/edit_images', :controller => 'admin/labels', :action => 'edit_images', :conditions => { :method => :get }
  map.admin_artist_images '/admin/artists/:id/edit_images', :controller => 'admin/artists', :action => 'edit_images', :conditions => { :method => :get }

  map.admin_content_edit_images '/admin/contents/:id/edit_images', :controller => 'admin/contents', :action => 'edit_images', :conditions => { :method => :get }
  map.admin_content_edit_music '/admin/contents/:id/edit_music', :controller => 'admin/contents', :action => 'edit_music_info', :conditions => { :method => :get }
  map.admin_content_edit_album '/admin/contents/:id/edit_album', :controller => 'admin/contents', :action => 'edit_album_info', :conditions => { :method => :get }

  map.admin_content_musics '/admin/contents/musics/:id.:format', :controller => 'admin/contents', :action => 'musics', :conditions => { :method => :get }


  map.resources(:contents, :collection => { :albums => :get, :musics => :get })
  map.resources :artists
  map.resources :labels

  map.resource :contact
  map.resource :cart
  map.resource :order
  map.resource :payment

  map.namespace :admin do |admin|
    admin.resources :contents
    admin.resources :artists
    #admin.resources(:labels, :member => { :images => :get })
    admin.resources :labels
    admin.resources :images
    admin.resources(:downloads, :member => { :dl => :get })
    admin.resource  :session
    admin.resources :users
    admin.resources :orders
    admin.resources :infos
  end


  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'

  # Catch 404s
  map.connect '*path', :controller => 'four_oh_fours'
  map.connect ':controller/:action/:id', :controller  => 'four_oh_fours'

end
