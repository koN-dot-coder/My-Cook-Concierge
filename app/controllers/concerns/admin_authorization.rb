module AdminAuthorization
  extend ActiveSupport::Concern

  private

  def require_admin
    return if admin?

    redirect_to root_path, alert: "管理者権限が必要です"
  end
end
