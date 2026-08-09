Rails.application.routes.draw do
  # アプリのトップページ（http://localhost:3000）へのアクセスを、今作った画面に設定します
  root "diagnostics#top"

  # 診断画面用のアドレス定義
  get "diagnostics/top", to: "diagnostics#top"
  post "diagnostics/start", to: "diagnostics#start"
  get "diagnostics/question", to: "diagnostics#question"
  post "diagnostics/answer", to: "diagnostics#answer"
  get "diagnostics/result", to: "diagnostics#result"

  # ヘルスチェック用のデフォルト設定（Rails 8で自動追加されたもの）
  get "up" => "rails/health#show", as: :rails_health_check
end
