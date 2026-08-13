class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :admin?

  private

  def admin?
    current_user&.admin?
  end

  def current_user
    Current.user
  end
end
