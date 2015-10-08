Rails.application.routes.draw do
  match '*all', to: 'application#preflight', via: [:options]

  scope 'api/v1' do
    resources :searches
    get 'welcome/index'
    root 'welcome#index'
  end

end
