Rails.application.routes.draw do
  # アプリのトップページ（http://localhost:3000）へのアクセスを、今作った画面に設定します
  root "diagnostics#top"

  # 診断画面用のアドレス定義
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

  # ヘルスチェック用のデフォルト設定（Rails 8で自動追加されたもの）
  get "up" => "rails/health#show", as: :rails_health_check
end
