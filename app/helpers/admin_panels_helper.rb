module AdminPanelsHelper
  def comments_left_opacity_class(comments_size)
    "opacity-#{comments_size == 0 ? "0" : "100"}"
  end

  def comments_left_display_class(comments_size)
    comments_size == 0 ? "block" : "hidden"
  end
end
