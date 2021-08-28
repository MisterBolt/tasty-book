class UserImageValidator < ActiveModel::Validator
  def validate(record)
    return unless record.avatar.attached?

    record.errors.add(:avatar, "is too big, max size is 10Mb") if record.avatar.byte_size > 10.megabytes
    record.errors.add(:avatar, "needs to be an image") unless record.avatar.content_type.starts_with?("image/")
  end
end
