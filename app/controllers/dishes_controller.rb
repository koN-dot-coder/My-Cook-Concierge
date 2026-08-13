class DishesController < ApplicationController
  include AdminAuthorization

  allow_unauthenticated_access only: %i[index show]
  before_action :require_admin, only: %i[new create edit update destroy]
  before_action :set_dish, only: %i[show edit update destroy]

  def index
    @dishes = Dish.order(:id).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @dish = Dish.new
  end

  def edit
  end

  def create
    @dish = Dish.new(dish_params)

    if @dish.save
      redirect_to @dish, notice: "料理を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @dish.update(dish_params)
      redirect_to @dish, notice: "料理を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @dish.destroy!
    redirect_to dishes_path, notice: "料理を削除しました"
  end

  private

  def set_dish
    @dish = Dish.find(params[:id])
  end

  def dish_params
    params.require(:dish).permit(:name, :description, :image_url, :recipe_url, :category, tag_ids: [])
  end
end
