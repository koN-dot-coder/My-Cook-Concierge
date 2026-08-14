class AccountsController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(account_params)
      redirect_to edit_account_path, notice: "アカウント情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user = current_user
    terminate_session
    user.destroy!
    redirect_to root_path, notice: "アカウントを削除しました"
  end

  private

  def account_params
    permitted = params.require(:user).permit(:name, :password, :password_confirmation)
    permitted.delete(:password) if permitted[:password].blank?
    permitted.delete(:password_confirmation) if permitted[:password].blank?
    permitted
  end
end
