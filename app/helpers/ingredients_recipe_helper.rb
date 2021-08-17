module IngredientsRecipeHelper
  def unit_short(unit)
    case unit
    when "gram"
      :g
    when "mililiter"
      :ml
    when "teaspoon"
      :tsp
    when "piece"
      :pcs
    end
  end
end
