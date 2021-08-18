class ImageValidator < ActiveModel::Validator
  def validate(record)
    if record.avatar.attached?
      if record.avatar.blob.byte_size > 1000000
        record.errors.add :avatar, "is too big"
      elsif !record.avatar.blob.content_type.starts_with?("image/")
        record.errors.add :avatar, "has wrong format"
      end
    end
  end
end
