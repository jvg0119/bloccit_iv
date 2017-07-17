module ApplicationHelper

  def form_tag_group(errors, &block)
    css_styling = "form-group"
    css_styling << " has-error" if errors.any?
    content_tag(:div, capture(&block), class: css_styling)
  end

  # def form_tag_group(errors, &block)
  #   if errors.any?
  #     content_tag(:div, capture(&block), class: "form-group has-error")
  #   else
  #     content_tag(:div, capture(&block), class: "form-group")
  #   end
  # end
  # form_tag_group(post.errors[:title])
  #<div class="form-group has-warning">


end
