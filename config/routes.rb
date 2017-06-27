Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
#---------------------TOPページルーティング------------------------
root to: "users#index"
#---------------------ユーザールーティング-------------------------
#ユーザーnewページルーティング
get "users/new"

post "users", to: "users#create"

#ユーザーloginページルーティング
get "users/login"
  
post "check", to: "users#check"
  
#ユーザーshowページルーディング
get "users/show/:id", to: "users#show", as:"user"

#ユーザーeditページルーティング
  get 'users/:id/edit', to:'users#edit', as:'user/edit'

  put 'users/:id/update', to:'users#update', as:'user/update'
#---------------------スケジュールルーティング--------------------
#indexページルーティング
get "index", to: "plans#index"

#showページルーティング
get "show/:id", to: "plans#show", as: "plans_show"

#showページの削除
delete "show/:id", to: "plans#destroy", as: "plans_destroy"

#newページルーティング
get "show/:id/new", to: "plans#new", as: "plans_new"

post "plans", to: "plans#create"

#editページルーティング
get "show/:id/edit", to: "plans#edit", as: "plans_edit"

put "show/:id", to: "plans#update", as: "plans_update"

post "logout", to: "users#logout", as: "user_logout"

#辞書ページルーティング
get 'dictionary', to: "plans#dictionary", as: "plans_dictionary"

#---------------------エラールーティング-----------------------
#error404ページルーティング
get '*path', controller: 'application', action: 'render_404'
end
