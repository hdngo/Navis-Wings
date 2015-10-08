Rails.application.routes.draw do
  match '*all', to: 'application#preflight', via: [:options]

  scope 'api/v1' do
    resources :searches do
      resources :results
    end
    get 'welcome/index'
    root 'welcome#index'
  end

end
