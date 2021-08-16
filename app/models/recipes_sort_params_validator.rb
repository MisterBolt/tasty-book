class RecipesSortParamsValidator
  include ActiveModel::Validations

  AVAILABLE_KINDS = ["title", "difficulty", "time_in_minutes_needed", "score"]
  AVAILABLE_ORDERS = ["ASC", "DESC"]

  attr_reader :data

  validates :page, :items,
    numericality: {only_integer: true, greater_than: 0},
    allow_blank: true
  validates :kind, inclusion: {in: AVAILABLE_KINDS}, allow_blank: true
  validates :order, inclusion: {in: AVAILABLE_ORDERS}, allow_blank: true

  def initialize(data)
    @data = data
  end

  def read_attribute_for_validation(key)
    data[key]
  end
end
