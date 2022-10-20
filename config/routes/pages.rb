# scope module: 'pages' do
  # root to: 'Pages::pages#landing'
  root to: 'pages#landing'
  get '/components', to: 'pages#components'
  get 'test', to: 'pages#test'
  get 'blank', to: 'pages#blank'
# end
