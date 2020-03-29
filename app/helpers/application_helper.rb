module ApplicationHelper
  def navbar_link(icon, title, url)
    link_to content_tag(:i, nil, class: icon), url, title: title
  end
end
