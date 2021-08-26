module LayoutsHelper
  def btn_nav_class_for_recipes(path)
    /^#{path}((?!new).)*$/.match?(request.path) ? "btn-nav-active" : "btn-nav"
  end

  def btn_nav_class_overall(path)
    /^#{path}/.match?(request.path) ? "btn-nav-active" : "btn-nav"
  end
end
