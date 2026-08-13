class TagsController < ApplicationController
  include AdminAuthorization

  allow_unauthenticated_access only: %i[index show]
  before_action :require_admin, only: %i[new create edit update destroy]
  before_action :set_tag, only: %i[show edit update destroy]

  def index
    @tags = Tag.order(:id).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @tag = Tag.new
  end

  def edit
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to @tag, notice: "タグを登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @tag.update(tag_params)
      redirect_to @tag, notice: "タグを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy!
    redirect_to tags_path, notice: "タグを削除しました"
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
