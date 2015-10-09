Rails.application.routes.draw do
  match '*all', to: 'application#preflight', via: [:options]

  scope 'api/v1' do
    resources :searches do
      resources :results
    end
    get 'welcome/index'
    root 'welcome#index'

    # serves "paginated" results
    get '/searches/:id/results/page/:result_offset' => 'results#show_page'
  end

end
