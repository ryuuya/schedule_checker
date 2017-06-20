Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
get "index", to: "plans#index"

#newページルーティング
get "users/new"

post "users", to: "users#create"

#loginページルーティング
get "users/login"
end
