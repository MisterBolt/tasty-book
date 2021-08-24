class RecipeImageValidator < ActiveModel::Validator
  def validate(record)
    return unless record.image.attached?

    record.errors.add(:image, "is too big, max size is 10Mb") if record.image.byte_size > 10.megabytes
    record.errors.add(:image, "needs to be an image") unless record.image.content_type.starts_with?("image/")
  end
end