class UsernameValidator < ActiveModel::Validator
  def validate(record)
    if record.username == "Guest"
      record.errors.add :username, "can't be 'Guest'"
    end
  end
end
