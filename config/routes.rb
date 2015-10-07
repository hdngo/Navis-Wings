Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  scope 'api/v1' do
    resources :searches
  end

end
