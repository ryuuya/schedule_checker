Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
#indexページルーティング
get "index", to: "plans#index"

#newページルーティング
get "users/new"

post "users", to: "users#create"

#loginページルーティング
get "users/login"

post "check", to: "users#check"

#showページルーティング
get "show/:id", to: "plans#show", as: "plans_show"

#showページの削除
delete "show/:id", to: "plans#destroy", as: "plans_destroy"

#editページルーティング
get "show/:id/edit", to: "plans#edit", as: "plans_edit"
end
