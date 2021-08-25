class AdminPanelPolicy < ApplicationPolicy
  def comments?
    user&.admin?
  end
end
