Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
#---------------------ユーザールーティング-------------------------
#ユーザーnewページルーティング
get "users/new"

post "users", to: "users#create"

#ユーザーloginページルーティング
get "users/login"

#ユーザーshowページルーディング
get "users/show/:id", to: "users#show", as:"user"

#---------------------スケジュールルーティング--------------------
#indexページルーティング
get "index", to: "plans#index"

#showページルーティング
get "show/:id", to: "plans#show", as: "plans_show"

#showページの削除
delete "show/:id", to: "plans#destroy", as: "plans_destroy"

#editページルーティング
get "show/:id/edit", to: "plans#edit", as: "plans_edit"
end
