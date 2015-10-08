Rails.application.routes.draw do
  

  scope 'api/v1' do
    resources :searches
    get 'welcome/index'
    root 'welcome#index'
  end

end
