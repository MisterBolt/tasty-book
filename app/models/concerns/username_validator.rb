class UsernameValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :username, "can't be 'Guest'" if record.username == "Guest"
    record.errors.add :username, "can't be 'Deleted_user'" if record.username.to_s.downcase.starts_with?("deleted_user")
  end
end
