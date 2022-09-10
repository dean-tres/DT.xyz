scope module: 'error_pages' do
  # get 'test_404', to: 'error_pages#not_found'
  get '/404', to: 'error_pages#not_found'
  # get '/test_500', to: 'error_pages#divide_by_zero'
  get '/500', to: 'error_pages#application_error'
end