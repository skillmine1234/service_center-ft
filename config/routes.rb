ServiceCenter::Application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :partners
  resources :purpose_codes
  resources :inward_remittances
  resources :whitelisted_identities
  resources :rules
  resources :banks

  get '/partner/:id/audit_logs' => 'partners#audit_logs'
  get '/purpose_code/:id/audit_logs' => 'purpose_codes#audit_logs'
  get '/rule/:id/audit_logs' => 'rules#audit_logs'
  get '/bank/:id/audit_logs' => 'banks#audit_logs'

  get '/inward_remittances/:id/remitter_identities' => 'inward_remittances#remitter_identities'
  get '/inward_remittances/:id/beneficiary_identities' => 'inward_remittances#beneficiary_identities'
  
  get '/download_attachment' => 'whitelisted_identities#download_attachment'
  
  get '/sdn/search' => 'aml_search#find_search_results'
  get '/sdn/search_results' => 'aml_search#results'
  get '/sdn/search_result' => 'aml_search#search_result'

  root :to => 'dashboard#overview'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  ActiveAdmin.routes(self)
end