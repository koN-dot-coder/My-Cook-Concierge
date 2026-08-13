Rails.application.routes.draw do
  resource :session
  get "logout/complete", to: "sessions#complete", as: :session_complete
  resource :registration, only: %i[new create], controller: "registrations"
  resources :passwords, param: :token

  root "diagnostics#top"

  get "diagnostics/top", to: "diagnostics#top"
  post "diagnostics/start", to: "diagnostics#start"
  get "diagnostics/question", to: "diagnostics#question"
  post "diagnostics/answer", to: "diagnostics#answer"
  get "diagnostics/result", to: "diagnostics#result"
  get "diagnostics/histories", to: "diagnostics#history_index", as: :diagnostic_histories
  delete "diagnostics/histories", to: "diagnostics#history_clear", as: :clear_diagnostic_histories
  get "diagnostics/histories/:id", to: "diagnostics#history_show", as: :diagnostic_history
  delete "diagnostics/histories/:id", to: "diagnostics#history_destroy"

  resources :dishes
  resources :tags

  get "terms", to: "pages#terms"
  get "privacy", to: "pages#privacy"

  get "favorites", to: "favorites#index", as: :favorites
  post "favorites/:dish_id", to: "favorites#create", as: :favorite_dish
  delete "favorites/:dish_id", to: "favorites#destroy"

  resource :account, only: %i[edit update]

  get "up" => "rails/health#show", as: :rails_health_check
end
