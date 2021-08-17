class CookBookPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        scope.visible_publicly.or(scope.followers(user.followings, user.id))
      else
        scope.visible_publicly
      end
    end
  end
end
