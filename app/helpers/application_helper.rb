module ApplicationHelper
  def tag_label(name)
    I18n.t("tags.#{name}", default: name.to_s)
  end
end
