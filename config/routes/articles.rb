# frozen_string_literal: true

get '/articles', to: 'articles#index'
get '/article/:permalink', to: 'articles#show'
get '/:permalink', to: 'articles#show'
