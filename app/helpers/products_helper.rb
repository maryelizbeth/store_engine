module ProductsHelper
  def display_boolean_icon(value)
    if value == true
      content_tag(:span, "", :class => "icon-ok").html_safe
    else
      content_tag(:span, "", :class => "icon-remove").html_safe
    end
  end
end
