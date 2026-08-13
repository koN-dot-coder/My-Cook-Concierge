class FavoritesController < ApplicationController
  def index
    @favorites = current_user.favorites.includes(:dish).order(created_at: :desc).page(params[:page]).per(10)
  end

  def create
    dish = Dish.find(params[:dish_id])
    current_user.favorites.find_or_create_by!(dish: dish)
    redirect_back fallback_location: favorites_path, notice: "お気に入りに追加しました"
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: favorites_path, alert: "料理が見つかりませんでした"
  end

  def destroy
    favorite = current_user.favorites.find_by!(dish_id: params[:dish_id])
    favorite.destroy!
    redirect_back fallback_location: favorites_path, notice: "お気に入りから削除しました"
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: favorites_path, alert: "お気に入りが見つかりませんでした"
  end
end
