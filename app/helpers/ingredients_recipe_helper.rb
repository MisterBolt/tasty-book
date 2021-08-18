module IngredientsRecipeHelper
  def unit(name,quantity)
    case name
    when "gram"
      :g
    when "ml"
      :ml
    when "teaspoon"
      :tsp
    when "tablespoon"
      :tbsp
    when "glass"
      if quantity > 1
        :glasses
      else
        :glass
      end
    end
  end
end
