class ImageValidator < ActiveModel::Validator
  def validate(record)
    if record.avatar.attached?
      if record.avatar.byte_size > 10.megabytes
        record.errors.add(:avatar, "is too big, max size is 10Mb")
      elsif !record.avatar.content_type.starts_with?("image/")
        record.errors.add(:avatar, "needs to be an image")
      end
    end
  end
end
