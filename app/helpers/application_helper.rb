module ApplicationHelper
  def tag_label(name)
    I18n.t("tags.#{name}", default: name.to_s)
  end

  def dish_image_src(source)
    return nil if source.blank?

    if source.start_with?("/")
      public_file = Rails.root.join("public", source.delete_prefix("/"))
      return source if File.exist?(public_file)

      nil
    else
      source
    end
  end

  def dish_image_src_for(dish)
    dish_image_src(dish&.image_url)
  end
end
