class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create complete]

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url, notice: "ログインしました"
    else
      redirect_to new_session_path, alert: "メールアドレスまたはパスワードが正しくありません"
    end
  end

  def destroy
    terminate_session
    redirect_to session_complete_path
  end

  def complete
  end
end
